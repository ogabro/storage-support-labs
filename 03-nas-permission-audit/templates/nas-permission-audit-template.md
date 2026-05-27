# NAS Permission Audit Template

## 1. Scope

- Client / environment:
- NAS or file server:
- Share path:
- Data category:
- Data/business owner:
- Audit date:
- Auditor:

## 2. Current Access Summary

| Principal | Type | Access Level | Source | Approved? | Notes |
| --- | --- | --- | --- | --- | --- |
| Example: Finance_Read | Group | Read | Share/ACL | Yes | Approved Finance readers group |
| Example: j.sara | User | Modify | Direct ACL | Unknown | Needs owner confirmation |

## 3. Findings

### Finding 1

- Severity:
- Evidence:
- Risk:
- Recommendation:
- Approval needed:
- Validation step:

### Finding 2

- Severity:
- Evidence:
- Risk:
- Recommendation:
- Approval needed:
- Validation step:

## 4. Risk Summary

| Severity | Count | Notes |
| --- | ---: | --- |
| High |  |  |
| Medium |  |  |
| Low |  |  |

## 5. Recommended Change Plan

| Step | Change | Owner Approval Required | Rollback / Fall-back | Validation |
| --- | --- | --- | --- | --- |
| 1 |  | Yes/No |  |  |

## 6. Validation Results

| Test | Expected Result | Actual Result | Pass/Fail |
| --- | --- | --- | --- |
| Test exact UNC path |  |  |  |
| Test intended access level |  |  |  |
| Test denied access if applicable |  |  |  |

## 7. Notes

- Do not grant broad access as a shortcut.
- Prefer group-based access over direct user exceptions.
- The data owner approves access; IT implements approved changes.
