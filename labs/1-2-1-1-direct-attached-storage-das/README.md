# Direct Attached Storage (DAS) — Sanitized Runbook / Lab

> Portfolio artifact. Every hostname, share, user, and ID below is fictional (lab environment). No real customer or workplace data.

## Goal

Create a sanitized fake runbook with a simple scenario, symptoms, first checks, evidence table, safe actions, and validation.

## Fictional Scenario

- NAS / array: `nas01.lab.example`
- Share / export: `\\nas01\finance-lab` (SMB) or `nas01:/exports/finance-lab` (NFS)
- Users: `sara.lab` (reports a problem), `ahmed.lab` (control user, working)

## What It Means

Direct Attached Storage (DAS) is storage connected straight to a single host with no storage network in between: internal disks, a USB drive, or a JBOD/enclosure cabled directly via SAS. The host owns that storage and other machines cannot easily share it. DAS is the simplest, often fastest, and cheapest option for one server, but it does not scale or share well, which is why networked options (NAS and SAN) exist.

## Operator View

Recognize DAS by the lack of a storage network: the disks belong to one host. It is great for local performance, simple setups, and cost, but its weaknesses are sharing, central management, and resilience if that host fails. Troubleshooting stays local: the controller/HBA, the cabling or enclosure, the disks, and the host filesystem. When a client outgrows DAS (needs sharing, central backup, or scale), that is the signal to discuss NAS or SAN.

## Why It Matters For Work

DAS vs NAS vs SAN is a foundational interview and design question, and knowing when DAS is the right simple answer (and when it is a bottleneck) shows real architectural judgment.

## Validation

Prove the exact intended access/behavior works, capture before/after evidence, and document the rollback path.
