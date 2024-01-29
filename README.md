# Keycloak Timoni module 

[![Release](https://img.shields.io/github/v/release/yyvess/keycloak-timoni.svg)](https://github.com//yyvess/keycloak-timoni/releases)
[![timoni.sh](https://img.shields.io/badge/timoni.sh-v0.18.0-7e56c2)](https://timoni.sh)
[![kubernetes](https://img.shields.io/badge/kubernetes-v1.29.0-326CE5?logo=kubernetes&logoColor=white)](https://kubernetes.io)
[![License](https://img.shields.io/github/license/nalum/cert-manager-module)](https://github.com/nalum/cert-manager-module/blob/main/LICENSE)

* [Keycloak](https://www.keycloak.org/) is an Open Source Identity and Access Management
* [Timoni.sh](http://timoni.sh) is an alternative of Helm chart based on [CUE](https://cuelang.org/)



A [timoni.sh](http://timoni.sh) module for deploying [keycloak](https://www.keycloak.org/) to Kubernetes clusters.


> [!IMPORTANT]
> Note that module is on beta, any feedback and PR are welcome

## Install

To create a minimum instance, create a file `my-values.cue` with the following content:

```cue
values: {
	admin: {
		password: {value: "admin"}
	}
	extraEnvs: [
		{name: "KC_HOSTNAME_STRICT", value: "false"},
		{name: "KC_LOG_LEVEL", value:       "INFO"},
	]
}
```



And apply the values with:

```shell
timoni -n keycloak apply keycloak oci://ghcr.io/yyvess/keycloak \
--values ./my-values.cue
```

By default, the server uses the **dev-file** database on an empty volume! The dev-file database **is not suitable for production use-cases**, and must be replaced with an others database type on production.

## Uninstall

To uninstall an instance and delete all its Kubernetes resources:

```shell
timoni -n keycloak delete keycloak
```

## Configuration

Some configuration examples can be found on [samples](samples) directory.
