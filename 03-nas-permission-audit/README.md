# NAS Permission Audit

## Problem

Small businesses and teams often grow file shares over time without a clean access model. Direct user exceptions, broad groups, and undocumented changes make it difficult to know who can access sensitive data and why.

This lab provides a safe, client-readable structure for reviewing NAS or file-share permissions without making risky changes first.

## Audit Principle

```text
Document -> classify risk -> confirm owner -> recommend smallest approved change -> validate
```

## What This Audit Checks

- Exact share path and business owner
- Sensitive data category
- Current groups and users with access
- Direct user permissions
- Broad access such as Everyone or Domain Users
- Access level: Read, Modify, Full Control
- Whether access is documented and approved
- Validation steps after approved changes

## Risk Scoring

| Risk | Meaning | Example |
| --- | --- | --- |
| High | Broad or dangerous access to sensitive data | Everyone Full Control on Payroll or HR |
| Medium | Access may be valid but needs owner confirmation | Direct user permission with no documented reason |
| Low | Access appears controlled and documented | Approved Finance group has Read access |

## Safe Audit Workflow

1. Identify the exact share path, such as `\\nas01\Finance`.
2. Identify the data/business owner.
3. Document current groups, users, and access levels.
4. Flag broad access and direct user exceptions.
5. Write findings in business-safe language.
6. Ask the owner to approve changes before implementation.
7. Validate exact intended access after approved changes.

## Approval Boundary

Do not remove permissions, replace inheritance, or grant broad access without owner approval. The audit report should separate technical findings from approved implementation.

## Included Files

- `templates/nas-permission-audit-template.md` - reusable audit template.
- `samples/sample-nas-permission-audit-report.md` - sample client-style report.
