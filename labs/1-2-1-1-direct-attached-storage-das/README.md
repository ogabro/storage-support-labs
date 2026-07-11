# Direct Attached Storage (DAS) - Missing Disk Runbook

> Portfolio artifact. Every hostname, device ID, and event below is fictional. No real customer or workplace data is used.

## Goal

Diagnose a directly attached disk that disappeared from one Linux host without confusing DAS with a NAS share or SAN LUN.

## Fictional Scenario

Host `db01.lab.example` uses a SAS HBA connected by cable to a JBOD enclosure. Device `/dev/sdb` was visible before planned maintenance but is now missing. The host remains online.

```text
db01 host -> SAS HBA/controller -> cable/backplane -> JBOD enclosure -> physical disk
```

There is no SMB path, NFS export, IP storage network, Fibre Channel fabric, zoning, or array masking in this scenario.

## What DAS Means

Direct Attached Storage is storage connected to one host without a storage network between the host and media. Examples include an internal NVMe device, internal RAID disks, a USB drive, or a SAS-attached JBOD. The operating system sees local block devices through its controller or HBA.

DAS can be simple and fast, but the attached host is part of the failure domain. Another server cannot automatically use the disks as shared storage. If the business later needs centralized sharing, independent controller failover, or many-host access, NAS or SAN may be a better architecture.

## Safety Boundary

Start with read-only observation. Do not format, initialize, clear foreign configuration, force-import RAID metadata, reseat production cables, reboot, or replace hardware without an approved change and a verified rollback/recovery plan.

## Read-Only Checks

| Step | Example | What it proves |
| --- | --- | --- |
| Confirm scope | `hostnamectl` and ticket details | The exact host and expected device are correct |
| List block devices | `lsblk -o NAME,SIZE,TYPE,FSTYPE,MOUNTPOINTS,MODEL,SERIAL` | Whether the OS currently sees the disk |
| Check PCI controller | `lspci \| grep -Ei 'sas\|scsi\|raid'` | Whether the SAS/RAID controller is visible to the OS |
| Review kernel evidence | `dmesg -T \| grep -Ei 'sas\|scsi\|raid\|reset\|error\|offline'` | Link resets, timeouts, device removal, or controller errors |
| Inspect SCSI inventory | `lsscsi -g` | The host-to-device inventory and generic device mapping |
| Check mounts | `findmnt` and `df -hT` | Whether an expected filesystem is mounted or missing |
| Check hardware state | Vendor HBA/JBOD read-only status command | Port, enclosure, disk, and RAID-state evidence |

Command availability varies by Linux distribution and controller vendor. Record missing tools instead of installing or changing packages during an incident without approval.

## Classification

| Evidence | Most likely layer |
| --- | --- |
| Controller missing from `lspci` | PCI, driver, firmware, power, or controller failure |
| Controller present; enclosure absent | SAS port, cable, expander/backplane, or enclosure power |
| Enclosure present; one disk absent/failed | Disk slot, media, or device failure |
| Disk visible in `lsblk`; filesystem absent | Partition, filesystem, mount, or `/etc/fstab` layer |
| Disk and mount visible; application fails | Ownership, permissions, capacity, or application layer |

## Evidence Record

| Item | Before | After | Expected result |
| --- | --- | --- | --- |
| Controller state | Capture model, driver, and health | Capture again | Controller remains online and healthy |
| Enclosure path | Missing or degraded path | Capture after approved repair | Expected enclosure and SAS path visible |
| Device identity | `/dev/sdb` missing | Record model/serial and current device name | Correct physical disk returns; do not rely on device name alone |
| Filesystem/mount | Not visible or not mounted | Record `findmnt` output | Intended filesystem mounted once at the approved path |
| Application check | Owner-provided failure | Owner-provided validation | Workload reads/writes as expected |

## Safe Action Pattern

1. Correlate the host, HBA, enclosure, and physical-disk evidence.
2. Identify the smallest approved action at the failed layer.
3. Record the current state and a rollback or recovery path.
4. Make one controlled change during the approved window.
5. Rescan only with the vendor/OS-approved method.
6. Validate device identity before mounting or allowing writes.

If data integrity, RAID metadata, or filesystem consistency is uncertain, stop and escalate. A disk becoming visible does not prove its data is safe.

## Validation

The ticket is complete only when:

- the expected controller, enclosure, and physical disk are healthy;
- the correct device is identified by stable attributes such as model, serial, or WWID;
- the expected filesystem is mounted at the correct path, if mounting is in scope;
- the workload owner validates intended read/write behavior;
- before/after evidence, action, risk, and rollback are documented.

## Interview Summary

"DAS has no storage network. I follow the local path from host to controller, cable/backplane, enclosure, disk, then filesystem and application. I collect read-only evidence first and never initialize or import storage metadata just because a disk is missing."
