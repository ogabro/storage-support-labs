<#
.SYNOPSIS
Creates a Markdown report for an SMB Access Denied troubleshooting case.

.DESCRIPTION
This script turns common ticket evidence into a client-readable report. It does
not change permissions, disconnect sessions, or modify the target system.
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$AffectedUser,

    [Parameter(Mandatory = $true)]
    [string]$FailingUncPath,

    [Parameter(Mandatory = $true)]
    [ValidateSet('Yes', 'No', 'Unknown')]
    [string]$UserCanAccessEmail,

    [Parameter(Mandatory = $true)]
    [ValidateSet('Yes', 'No', 'Unknown')]
    [string]$UserCanAccessOtherShareSameServer,

    [Parameter(Mandatory = $true)]
    [ValidateSet('Yes', 'No', 'Unknown')]
    [string]$OtherUserCanAccessFailingShare,

    [Parameter(Mandatory = $true)]
    [ValidateSet('OneComputer', 'MultipleComputers', 'Unknown')]
    [string]$ComputerScope,

    [string]$ErrorMessage = 'Access denied',

    [string]$OutputPath = '.\smb-access-denied-report.md'
)

function Get-LikelyCategory {
    param(
        [string]$UserCanAccessEmail,
        [string]$UserCanAccessOtherShareSameServer,
        [string]$OtherUserCanAccessFailingShare,
        [string]$ComputerScope
    )

    if ($UserCanAccessEmail -eq 'No' -and $UserCanAccessOtherShareSameServer -eq 'No') {
        return 'Authentication or account issue likely'
    }

    if (($UserCanAccessEmail -eq 'Yes' -or $UserCanAccessOtherShareSameServer -eq 'Yes') -and
        $OtherUserCanAccessFailingShare -eq 'Yes') {
        return 'Permissions or authorization issue likely'
    }

    if ($ComputerScope -eq 'OneComputer') {
        return 'Workstation, cached credential, or mapped-drive session issue possible'
    }

    return 'Needs more evidence before classification'
}

$likelyCategory = Get-LikelyCategory `
    -UserCanAccessEmail $UserCanAccessEmail `
    -UserCanAccessOtherShareSameServer $UserCanAccessOtherShareSameServer `
    -OtherUserCanAccessFailingShare $OtherUserCanAccessFailingShare `
    -ComputerScope $ComputerScope

$identityEvidence = if ($UserCanAccessEmail -eq 'Yes' -or $UserCanAccessOtherShareSameServer -eq 'Yes') {
    'The affected user can authenticate somewhere else, so identity is probably working.'
} elseif ($UserCanAccessEmail -eq 'No' -and $UserCanAccessOtherShareSameServer -eq 'No') {
    'The affected user fails multiple access points, so identity/account state needs checking first.'
} else {
    'Identity evidence is incomplete.'
}

$targetEvidence = if ($OtherUserCanAccessFailingShare -eq 'Yes') {
    'Another user can access the failing share, so the target share/path is probably available.'
} elseif ($OtherUserCanAccessFailingShare -eq 'No') {
    'Other users also fail, so check share-wide permissions, service health, or recent server/NAS changes.'
} else {
    'Target share evidence is incomplete.'
}

$workstationEvidence = if ($ComputerScope -eq 'MultipleComputers') {
    'The affected user fails from multiple computers, so a single-workstation cache issue is less likely.'
} elseif ($ComputerScope -eq 'OneComputer') {
    'Failure is limited to one computer, so cached credentials, mapped drives, or workstation state should be checked.'
} else {
    'Computer scope is unknown.'
}

$report = @"
# SMB Access Denied Report

## Case Summary

- Affected user: $AffectedUser
- Failing UNC path: $FailingUncPath
- Error message: $ErrorMessage
- Likely category: **$likelyCategory**

## Evidence

| Question | Answer |
| --- | --- |
| User can access email | $UserCanAccessEmail |
| User can access another share on same server | $UserCanAccessOtherShareSameServer |
| Another user can access failing share | $OtherUserCanAccessFailingShare |
| Computer scope | $ComputerScope |

## Evidence Interpretation

- Identity: $identityEvidence
- Target share/path: $targetEvidence
- Workstation scope: $workstationEvidence

## First Checks Before Changing Anything

1. Confirm expected user account and domain.
2. Check required group membership.
3. Check share permissions.
4. Check filesystem or NAS ACL permissions.
5. Check saved credentials or mapped-drive session conflicts if the issue follows one workstation.

## Safe Change Boundary

Do not grant broad access, remove ACLs, or change inheritance without owner approval. Make the smallest approved change and document the before/after state.

## Validation

After an approved change, validate the exact UNC path and the expected access level:

$FailingUncPath
"@

$outputDirectory = Split-Path -Path $OutputPath -Parent
if ($outputDirectory) {
    New-Item -ItemType Directory -Force -Path $outputDirectory | Out-Null
}

$report | Set-Content -Path $OutputPath -Encoding UTF8 -Force
Write-Output "Created report: $OutputPath"


