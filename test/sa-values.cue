// Custome Service account

@if(!debug)

package main

// Defaults
values: {

	replicas: 1

	image: {
		repository: "quay.io/keycloak/keycloak"
		digest:     "sha256:cff31dc6fbb0ab0b66176b990e6b9e262fa74a501abb9a4bfa4a529cbc8a526a"
		tag:        "23.0"
	}

	serviceAccountCreate: true
	serviceAccount: {
		metadata: {
			name: "kjj"
			annotations: {"custom": "test"}}
	}
	admin: {
		password: {value: "admin"}
	}
}
