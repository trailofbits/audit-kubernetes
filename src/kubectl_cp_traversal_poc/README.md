# PoC Directory Traveral in kubectl cp (1.13.5)

## Getting Started

### Prerequisites

* Python2
* kind installed

### Setup

```bash
$ kind create cluster
$ export KUBECONFIG="$(kind get kubeconfig-path --name="kind")"
$ git submodule init
$ git submodule update
```

### Running PoC

This PoC will write a sample file (i.e., .bashrc) into /tmp. Modifying poc.py can place this anywhere in the user's path.

```bash
$ make kubernetes
$ make test
```
