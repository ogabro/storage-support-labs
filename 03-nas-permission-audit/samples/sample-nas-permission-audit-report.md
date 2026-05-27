# Sample NAS Permission Audit Report

## 1. Scope

- Client / environment: Example Company
- NAS or file server: nas01
- Share path: `\\nas01\Finance`
- Data category: Finance records
- Data/business owner: Finance Manager
- Audit date: May 27, 2026
- Auditor: Storage support engineer

## 2. Current Access Summary

| Principal | Type | Access Level | Source | Approved? | Notes |
| --- | --- | --- | --- | --- | --- |
| Finance_Read | Group | Read | Share/ACL | Yes | Approved Finance readers group |
| Finance_Modify | Group | Modify | Share/ACL | Yes | Approved Finance editors group |
| Everyone | Group | Full Control | Share permission | No | Broad access to sensitive Finance data |
| sara.a | User | Modify | Direct ACL | Unknown | Direct user exception needs owner review |

## 3. Findings

### Finding 1: Broad Access On Sensitive Share

- Severity: High
- Evidence: `Everyone` has `Full Control` on `\\nas01\Finance`.
- Risk: Broad access may expose or allow modification/deletion of sensitive Finance data.
- Recommendation: Review with the Finance data owner and replace broad access with approved Finance groups.
- Approval needed: Finance data owner approval required before permission changes.
- Validation step: Confirm only approved Finance groups can access the exact UNC path with intended access levels.

### Finding 2: Undocumented Direct User Permission

- Severity: Medium
- Evidence: `sara.a` has direct `Modify` access on the Finance share.
- Risk: Direct user exceptions make audits harder and can leave access in place after role changes.
- Recommendation: Confirm business reason with Finance owner. If valid, move access into an approved group with documented scope and duration.
- Approval needed: Finance data owner approval required.
- Validation step: Confirm Sara's intended access through group membership and remove direct ACL only after approval.

## 4. Risk Summary

| Severity | Count | Notes |
| --- | ---: | --- |
| High | 1 | Broad Full Control on sensitive share |
| Medium | 1 | Direct user exception needs confirmation |
| Low | 0 | No low-risk findings listed |

## 5. Recommended Change Plan

| Step | Change | Owner Approval Required | Rollback / Fall-back | Validation |
| --- | --- | --- | --- | --- |
| 1 | Replace Everyone Full Control with approved Finance groups | Yes | Restore documented previous permission if access breaks | Test `\\nas01\Finance` using approved and non-approved accounts |
| 2 | Move Sara's access to approved Finance group if justified | Yes | Keep documented direct permission until approved replacement is validated | Confirm Sara has only intended access |

## 6. Validation Results

| Test | Expected Result | Actual Result | Pass/Fail |
| --- | --- | --- | --- |
| Approved Finance reader opens `\\nas01\Finance` | Read succeeds | Pending | Pending |
| Approved Finance editor modifies test file | Modify succeeds | Pending | Pending |
| Non-Finance user opens `\\nas01\Finance` | Access denied | Pending | Pending |

## 7. Notes

This sample report intentionally avoids making changes before approval. Access to Finance data is a business decision; IT should implement the smallest approved change and document the before/after state.
