param(
    [string]$OutputPath = ".\mapped-drive-report.md"
)

$ErrorActionPreference = "Stop"

function Write-Line {
    param(
        [System.Collections.Generic.List[string]]$Lines,
        [string]$Text = ""
    )
    $Lines.Add($Text) | Out-Null
}

$lines = [System.Collections.Generic.List[string]]::new()
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

Write-Line $lines "# Mapped Drive Report"
Write-Line $lines
Write-Line $lines "- Generated: $timestamp"
Write-Line $lines "- Computer: $env:COMPUTERNAME"
Write-Line $lines "- User: $env:USERNAME"
Write-Line $lines
Write-Line $lines "## Mapped Drives"
Write-Line $lines

$drives = @()

try {
    $drives = Get-CimInstance Win32_LogicalDisk -Filter "DriveType = 4" |
        ForEach-Object {
            [pscustomobject]@{
                DeviceID = $_.DeviceID
                ProviderName = $_.ProviderName
                VolumeName = $_.VolumeName
            }
        }
} catch {
    Write-Line $lines "> Win32_LogicalDisk query failed: $($_.Exception.Message)"
    Write-Line $lines
    Write-Line $lines "Falling back to PowerShell drive provider data."
    Write-Line $lines

    $drives = Get-PSDrive -PSProvider FileSystem |
        Where-Object { $_.DisplayRoot -like "\\*" } |
        ForEach-Object {
            [pscustomobject]@{
                DeviceID = "$($_.Name):"
                ProviderName = $_.DisplayRoot
                VolumeName = $_.Description
            }
        }
}

if (-not $drives) {
    Write-Line $lines "No mapped network drives were detected."
} else {
    Write-Line $lines "| Drive | UNC Path | Volume | Basic Path Test |"
    Write-Line $lines "| --- | --- | --- | --- |"

    foreach ($drive in $drives) {
        $path = $drive.ProviderName
        $test = "Not tested"

        if ($path) {
            try {
                if (Test-Path -LiteralPath $path) {
                    $test = "Reachable"
                } else {
                    $test = "Not reachable"
                }
            } catch {
                $test = "Error: $($_.Exception.Message)"
            }
        }

        Write-Line $lines "| $($drive.DeviceID) | $path | $($drive.VolumeName) | $test |"
    }
}

Write-Line $lines
Write-Line $lines "## Interpretation Guide"
Write-Line $lines
Write-Line $lines "- Drive letter fails but UNC path works: likely mapping/session/client issue."
Write-Line $lines "- UNC path fails for everyone: check server/NAS, SMB service, share, network, DNS, firewall."
Write-Line $lines "- UNC path fails for one user: check account, group membership, share permissions, filesystem permissions."
Write-Line $lines "- Name fails but IP works: likely DNS/name resolution."
Write-Line $lines
Write-Line $lines "## Safe Next Actions"
Write-Line $lines
Write-Line $lines "1. Confirm the expected UNC path using the format ``\\server\share``."
Write-Line $lines "2. Record the exact error message."
Write-Line $lines "3. Confirm whether the issue affects one user, one computer, or everyone."
Write-Line $lines "4. Avoid broad permission changes without approval."

$resolved = Resolve-Path -Path (Split-Path -Parent $OutputPath) -ErrorAction SilentlyContinue
if (-not $resolved -and (Split-Path -Parent $OutputPath)) {
    New-Item -ItemType Directory -Path (Split-Path -Parent $OutputPath) -Force | Out-Null
}

Set-Content -Path $OutputPath -Value $lines -Encoding utf8
Write-Host "Report written to $OutputPath"
