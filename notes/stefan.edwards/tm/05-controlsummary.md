# Control Summary

[CNSSI](https://rmf.org/wp-content/uploads/2017/10/CNSSI-4009.pdf) defines "security control" as:

> The management, operational, and technical controls (i.e., safeguards or countermeasures) prescribed for an information system to protect the confidentiality, integrity, and availability of the system and its information.

Controls are grouped by type or _family_, which collect controls along logical groupings, such as Auditing or Logging. This assessment will focus on six primary control families:

| Family Name | Description |
| :---: | :---: |
| Authorization | Related to authorization of users and assessment of rights |
| Authentication | Related to the identification of users |
| Cryptography | Related to protecting the privacy or integrity of data |
| Secrets Management | Related to the handling of sensitive application secrets such as password |
| Networking | Related to the protocols and connections between cluster and application components |
| Multi-tennacy | Related to the safe handling of two or more separate organizational groups within a cluster |

Additionally, we will keep the following families in mind throughout our review:

| Family Name | Description |
| :---: | :---: |
| Auditing and Logging | Related to auditing of actions or logging of problems |
| Configuration | Related to security configurations of servers, devices or software |
| Data Exposure | Related to unintended exposure of sensitive information |
| Data Validation | Related to improper reliance on the structure or values of data |
| Denial of Service | Related to causing system failure |
| Error Reporting | Related to the reporting of error conditions in a secure fashion |
| Patching | Related to keeping software up to date |
| Session Management | Related to the identification of authenticated users |
| Timing | Related to race conditions, locking or order of operations |
| Undefined Behavior | Related to undefined behavior triggered by the program |

Our review assessed the controls along the following criteria:

- Strong: controls were well implemented, centrally located, non-bypassable, and robustly designed.
- Adequate: controls were implemented to industry-standard best practice guidelines.
- Weak: controls were either partially unimplemented, applied, or contained flaws in their design or location.
- Missing: an entire family of control was missing from a component.
- Not Applicable: this control family is not needed for protecting the current component.

| Kubernetes Component | Control Family | Strength | Description |
| :---: | :---: | :---: | :---: |
| Will | Fill | In | Later |
