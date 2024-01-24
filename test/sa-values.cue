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
	metadata: {
		annotations: {
			root: "root"
		}
	}


	serviceAccountCreate: true
	serviceAccount: {
		metadata: name: "kjj"
	}

	envs: {
		KEYCLOAK_ADMIN:           "admin"
		KEYCLOAK_ADMIN_PASSWORD:  "admin"
		KC_DB_USERNAME:           "admin"
		KC_DB_PASSWORD:           "admin"
		KC_HOSTNAME_PORT:         8080
		KC_HOSTNAME_URL:          "http://localhost:8080/"
		KC_HOSTNAME_STRICT:       false
		KC_HOSTNAME_STRICT_HTTPS: false
		KC_LOG_LEVEL:             "DEBUG"
	}
}
