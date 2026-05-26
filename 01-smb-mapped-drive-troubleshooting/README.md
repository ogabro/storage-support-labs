# SMB Mapped Drive Troubleshooting

## Problem

A user reports that a mapped drive such as `Z:` is missing, disconnected, or showing an access error.

The drive letter is only a shortcut. The real target is usually a UNC path:

```text
Z: -> \\server\share
```

Example:

```text
Z: -> \\nas01\Shared
```

## Troubleshooting Model

```text
Mapped drive fails
  |
  |-- Test the UNC path directly: \\server\share
        |
        |-- UNC works
        |     -> Drive mapping, credential/session, or local client issue
        |
        |-- UNC fails
              -> SMB/share/network/authentication/permission issue
```

## Error Clues

| Symptom | Likely Area |
| --- | --- |
| Drive letter fails, UNC works | Mapping/session issue |
| Access denied | Authentication or permissions |
| Server name fails, IP works | DNS/name resolution |
| Everyone fails | Server, share, network, SMB service, DNS, firewall |
| One user fails | Account, group membership, share/filesystem permissions |
| One computer fails | Local credentials, mapping cache, VPN/client state |

## Safe Fix Sequence

1. Identify the drive letter and UNC path.
2. Test the UNC path directly.
3. Confirm whether impact is one user, one computer, or everyone.
4. Review the exact error message.
5. Disconnect stale mappings only after documenting current state.
6. Clear saved credentials only with approval.
7. Reconnect using the correct UNC path.
8. Validate expected read/write access.
9. Document findings and changes.

## Do Not Do Without Approval

- Grant broad permissions such as Everyone full control.
- Delete or recreate shares.
- Restart a production NAS/server during business hours.
- Remove user data.
- Make permission changes without recording before/after state.

## Included Tools

- `scripts/Get-MappedDriveReport.ps1`: Creates a Markdown report of mapped drives and basic UNC connectivity.
- `samples/sample-mapped-drive-report.md`: Example client-readable report.

