bundle: {
	apiVersion: "v1alpha1"
	name:       "keycloak"
	instances: {
		keycloak: {
			module: url:     "oci://ghcr.io/yyvess/keycloak"
			module: version: "0.0.0"
			namespace: "keycloak"
			values: envs: {
				KEYCLOAK_ADMIN_PASSWORD: "admin"
				KC_HOSTNAME_STRICT:      false
			}
		}
	}
}
