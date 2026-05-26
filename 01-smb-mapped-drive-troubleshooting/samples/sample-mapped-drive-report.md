# Mapped Drive Report

- Generated: 2026-05-26 21:00:00
- Computer: CLIENT-01
- User: omar

## Mapped Drives

| Drive | UNC Path | Volume | Basic Path Test |
| --- | --- | --- | --- |
| Z: | `\\nas01\Shared` | Shared | Reachable |
| F: | `\\nas01\Finance` | Finance | Not reachable |

## Interpretation

`Z:` is reachable, so the NAS and basic name resolution may be working.

`F:` is not reachable. Next checks:

1. Confirm whether `\\nas01\Finance` exists.
2. Check whether the issue affects one user or everyone.
3. If the error is Access denied, check account, group membership, share permissions, and filesystem permissions.
4. If `\\nas01\Finance` fails but `\\10.0.0.5\Finance` works, check DNS/name resolution.

## Safe Recommendation

Do not change broad permissions yet. First confirm the exact error message and impact scope.

