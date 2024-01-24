// Note that this file must have no imports and all values must be concrete.

// Unsecure Keycloak deployment in http with HA

@if(!debug)

package main

// Defaults
values: {

	replicas: 4

	pdbSpec: {
		minAvailable: 2
		maxUnavailable: 1
	}

	envs: {
		KEYCLOAK_ADMIN:          "admin"
		KEYCLOAK_ADMIN_PASSWORD: "admin"
	}
}
