# Finding Title

- Severity: Informational, Low, Medium, High, Critical
- Difficulty: Low, Medium, High
- Category: See Below
- Finding ID: TOA-K8S-NNN (three-digit number, from 001 to 999)

## Location

- list of files with line numbers
- **OR** list of components
- **OR** host:port

## Description

Paragraph form describing the situation:

The component does $THING, which allows $ACTOR to do $BADTHING...

## Steps to Reproduce

1. Numbered list of steps
1. to reproduce the finding
1. or the process by which you discovered the finding

## Exploit Scenario

Alice-and-Bob-style scenario of why this is bad, e.g.:

Alice wishes to interact with a Kubernetes service hosted by Bob. However, Mallory is able to
use a misconfiguration to...

## Remediation

Describe the short and long term fixes for Kubernetes.

Short term, do...

Long term, do...

# Notes

## Categories 

| Category name | Description |
| --- | --- |
| Access Controls | Related to authorization of users and assessment of rights |
| Auditing and Logging | Related to auditing of actions or logging of problems |
| Authentication | Related to the identification of users |
| Configuration | Related to security configurations of servers, devices or software |
| Cryptography | Related to protecting the privacy or integrity of data |
| Data Exposure | Related to unintended exposure of sensitive information |
| Data Validation | Related to improper reliance on the structure or values of data |
| Denial of Service | Related to causing system failure |
| Error Reporting | Related to the reporting of error conditions in a secure fashion |
| Numerics | Related to numeric calculations |
| Patching | Related to keeping software up to date |
| Session Management | Related to the identification of authenticated users |
| Timing | Related to race conditions, locking or order of operations |
| Undefined Behavior | Related to undefined behavior triggered by the program |

