# Storage Support Labs

Practical storage and hybrid infrastructure troubleshooting labs, diagnostic scripts, and client-ready runbooks.

This repo is built around real support patterns:

- SMB and mapped drive failures
- NAS access and permission review
- NFS/SMB troubleshooting
- Linux storage checks
- Backup repository and restore validation
- Hybrid storage support workflows

The goal is simple: turn infrastructure troubleshooting into repeatable checks, clear reports, and safe client-facing recommendations.

## Current Labs

| Lab | Focus | Status |
| --- | --- | --- |
| `01-smb-mapped-drive-troubleshooting` | Windows mapped drives, UNC paths, SMB access errors | In progress |
| `02-smb-access-denied-decision-tree` | Authentication vs permissions, one-user access denied, safe permission checks | In progress |

## Operating Style

Every lab should include:

- A short problem statement
- A decision tree
- A diagnostic script or command checklist
- A sample report
- Safe actions vs actions requiring approval

## Why This Exists

Storage support is rarely one isolated technology. A simple "mapped drive is broken" ticket may involve:

```text
Windows client -> DNS/VPN/network -> SMB server/NAS -> share permission -> filesystem ACL
```

This repo captures those layers in a way that is useful for support, consulting, and enterprise infrastructure work.
