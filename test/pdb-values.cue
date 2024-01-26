// Note that this file must have no imports and all values must be concrete.

// Unsecure Keycloak deployment in http with HA

@if(!debug)

package main

// Defaults
values: {

	replicas: 4

	pdb: {
		minAvailable:   2
		maxUnavailable: 1
	}

	database: {
		type: {value: "postgres"}
	}
	admin: {
		password: {value: "admin"}
	}

	java: {
		options: "-Xms256m"
	}
}
