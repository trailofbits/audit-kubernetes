# Threat Actors

Similarly to Trust Zones, defining malicious actors ahead of time is useful in determining which protections, if any, are necessary to mitigate or remediate a vulnerability.
Furthermore, we will use these actors in all subsequent findings from the threat model. Additionally, we define other "users" of the system, who may be impacted, or enticed 
to under take an attack. For example, a Confused Deputy attack such as Cross-Site Request Forgery would have a normal user as both the victim and the potential direct attacker,
even though a secondary attacker enticed the user to undertake the action.

| Actor | Description |
| :---: | :---: |
| Malicious Internal User | A user, such as an administrator or developer, who uses their privileged position maliciously against the system, or stolen credentials used for the same |
| Internal Attacker | An attacker who had transited one or more trust boundaries, such as an attacker with container access |
| External Attacker | An attacker who is external to the cluster and is unauthenticated |
| Administrator | An actual administrator of the system, tasked with operating and maintaing the cluster as a whole |
| Developer | An application developer who is deploying an application to a cluster, either directly or via another user (such as an Administrator) |
| End User | An external user of an application hosted by a cluster |

Additionally, attackers' paths through the various zones is useful when analzing potential controls, remediations, and mitigations that exist within the current architecture:

| Actor | Originating Zone | Destination Zone(s) | Description |
| :---: | :---: | :---: | :---: |
| Malicious Internal User | Any | Any | Malicious Internal Users are often privileged and have access to a wide range of resources; therefore, controls must be in place to ensure users are authorized to undertake an action and log all actions within the system, for strong non-repudation of actions |
| Internal Attacker | Container | Containers in another namespace, Worker, API Server, Master Components, Master Data | Attackers who had transited external boundaries and attained position on an internal container will seek to escalate privileges by accessing items in the API Server or Master Data zones, or parlay their access to other internal components of other Worker nodes |
| External Attacker | Internet | Container, Worker, API Server | External Attackers will seek to transit network edges in order to become Internal Attackers, or utilize exposed API Server functionality to escalate privileges |
