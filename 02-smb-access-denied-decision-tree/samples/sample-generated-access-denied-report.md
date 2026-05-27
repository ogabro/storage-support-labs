# SMB Access Denied Report

## Case Summary

- Affected user: Youssef
- Failing UNC path: \\fileserver01\Projects
- Error message: Access denied
- Likely category: **Permissions or authorization issue likely**

## Evidence

| Question | Answer |
| --- | --- |
| User can access email | Yes |
| User can access another share on same server | Yes |
| Another user can access failing share | Yes |
| Computer scope | MultipleComputers |

## Evidence Interpretation

- Identity: The affected user can authenticate somewhere else, so identity is probably working.
- Target share/path: Another user can access the failing share, so the target share/path is probably available.
- Workstation scope: The affected user fails from multiple computers, so a single-workstation cache issue is less likely.

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

\\fileserver01\Projects
