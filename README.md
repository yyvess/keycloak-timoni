# keycloak

A [timoni.sh](http://timoni.sh) module for deploying [keycloak](https://www.keycloak.org/) on Kubernetes clusters.

> [!IMPORTANT]
> Note that module in under development and is still in its infancy.
> Any feedback and PR are welcome


## Install

To create an instance, create a file `my-values.cue` with the following content:

```cue
values: {
	envs: {
		KEYCLOAK_ADMIN_PASSWORD: "admin"
		KC_HOSTNAME_STRICT:       false
	}
}
```

And apply the values with:

```shell
timoni -n keycloak apply keycloak oci://ghcr.io/yyvess/keycloak \
--values ./my-values.cue
```

By default, the server uses the dev-file database. This is the default database that the server will use to persist data and only exists for development use-cases. The dev-file database **is not suitable for production use-cases**, and must be replaced before deploying to production.


## Uninstall

To uninstall an instance and delete all its Kubernetes resources:

```shell
timoni -n keycloak delete keycloak
```

## Configuration

Look samples on test folder