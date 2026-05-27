# SMB Access Denied Decision Tree

## Problem

A user can reach an SMB share path, but Windows returns:

```text
Access denied
```

This usually means the server and share exist, but the user is blocked by authentication or permissions.

## Key Distinction

Authentication asks:

```text
Who are you?
```

Permissions ask:

```text
What are you allowed to do?
```

## Decision Tree

```text
Access denied
  |
  |-- Can other users access the same share?
  |     |
  |     |-- Yes
  |     |     -> User-specific issue
  |     |        Check account, credential/session, group membership,
  |     |        share permission, filesystem permission
  |     |
  |     |-- No
  |           -> Broader share or group issue
  |              Check share permission, filesystem ACL, service changes,
  |              recent group policy or NAS/server changes
  |
  |-- Can the same user access other shares on the same server?
        |
        |-- Yes
        |     -> The server and DNS are likely OK
        |
        |-- No
              -> Check authentication, account state, VPN/network,
                 or broader server access
```

## First Questions To Ask

1. What exact UNC path fails? Example: `\\nas01\Finance`.
2. What exact error appears?
3. Is it one user, one computer, or everyone?
4. Can the user access other shares on the same server?
5. Can other users access this share?
6. Did user, group, permission, password, NAS, or server changes happen recently?

## First Technical Checks

1. Confirm the user is authenticated with the expected account/domain.
2. Check for stale saved credentials or session conflict.
3. Check group membership.
4. Check share permissions.
5. Check filesystem/NTFS/NAS ACL permissions.
6. Compare with a known-good user if approved.

## Safe Actions

- Document current access and group membership.
- Confirm expected access with the client/owner.
- Test with direct UNC path.
- Avoid broad permission changes.
- Make the smallest approved change.
- Validate read/write access according to the intended role.

## Do Not Do Without Approval

- Grant Everyone full control.
- Add users to privileged groups without owner approval.
- Remove existing ACLs.
- Replace inheritance or permission structure blindly.
- Restart file services during business hours.

## Sample Report

See:

```text
samples/one-user-access-denied-report.md
```

