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

	admin: {
		password: {
			valueFrom: {
				secretKeyRef: {
					name: "my-secret"
					key:  "my-key"
				}
			}
		}
	}

	extraEnvs: [
		{name: "KC_HOSTNAME_PORT", value:         "8080"},
		{name: "KC_HOSTNAME_URL", value:          "http://localhost:8080/"},
		{name: "KC_HOSTNAME_STRICT", value:       "false"},
		{name: "KC_HOSTNAME_STRICT_HTTPS", value: "false"},
		{name: "KC_LOG_LEVEL", value:             "DEBUG"},
	]
}
