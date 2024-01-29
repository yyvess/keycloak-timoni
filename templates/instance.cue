package templates

// Instance takes the config values and outputs the Kubernetes objects.
#Instance: {
	config:           #Config
	highAvailability: config.replicas > 1
	objects: {

		namespace: #Namespace & {#config: config}

		if config.serviceAccountCreate {
			sa: #ServiceAccount & {#config: config}
		}
		if config.certificateCreate {
			cert: #Certificate & {#config: config}
		}
		if config.jksCreate {
			// Next version of certmanager the secret should optional and can be remove
			// https://github.com/cert-manager/cert-manager/pull/6657#discussion_r1464958155
			jksPassword: #JksSecret & {#config: config}
			jks: #JKS & {
				#config:     config
				#secretName: jksPassword.metadata.name
			}
		}
		if config.issuerCreate {
			issuer: #Issuer & {#config: config}
		}
		svcHttp: #ServiceHttp & {#config: config}
		if highAvailability {
			svcJgroup: #ServiceJgroup & {#config: config}
			cm: #ConfigMapIspn & {#config: config}
		}

		if config.pdbCreate {
			pdb: #PodDisruptionBudget & {#config: config}
		}

		if config.networkPolicyCreate {
			networkPolicy: #NetworkPolicy & {
				#config:           config
				#highAvailability: highAvailability
			}
		}

		if config.virtualService != _|_ {
			virtualService: #VirtualService & {
				#config: config
			}
		}

		if config.ingress != _|_ {
			virtualService: #Ingress & {
				#config: config
			}
		}

		deploy: #Deployment & {
			#config:           config
			#highAvailability: highAvailability
			#cmName:           *objects.cm.metadata.name | ""
			if objects.cert.spec.secretName != _|_ {
				#certSecretName: objects.cert.spec.secretName
			}
			if objects.jks.spec.secretName != _|_ {
				#jksSecretName: objects.jks.spec.secretName
			}
			#envs: [
				{name: "KEYCLOAK_ADMIN"} & config.admin.user,
				{name: "KEYCLOAK_ADMIN_PASSWORD"} & config.admin.password,
				if config.database.type != _|_ {
					{name: "KC_DB"} & config.database.type
				},
				if config.database.url != _|_ {
					{name: "KC_DB_URL"} & config.database.url
				},
				if (config.database.username != _|_) {
					{name: "KC_DB_USERNAME"} & {config.database.username}
				},
				if (config.database.password != _|_) {
					{name: "KC_DB_PASSWORD"} & {config.database.password}
				},
			]
		}
	}
}
