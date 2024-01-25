// Note that this file must have no imports and all values must be concrete.

// Unsecure Keycloak deployment in http with HA

@if(!debug)

package main

// Defaults
values: {

	image: {
		repository: "quay.io/keycloak/keycloak"
		digest:     "sha256:cff31dc6fbb0ab0b66176b990e6b9e262fa74a501abb9a4bfa4a529cbc8a526a"
		tag:        "23.0"
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

		KC_LOG_LEVEL: "DEBUG"
	}
}
