package templates

// Instance takes the config values and outputs the Kubernetes objects.
#Instance: {
	config: #Config
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
		if config.ha {
			svcJgroup: #ServiceJgroup & {#config: config}
			cm: #ConfigMapIspn & {#config: config}
		}

		if config.pdbCreate {
			pdb: #PodDisruptionBudget & {#config: config}
		}

		if config.networkPolicyCreate {
			networkPolicy: #NetworkPolicy & {
				#config: config
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
			#config: config
			#cmName: *objects.cm.metadata.name | ""
			if objects.cert.spec.secretName != _|_ {
				#certSecretName: objects.cert.spec.secretName
			}
			if objects.jks.spec.secretName != _|_ {
				#jksSecretName: objects.jks.spec.secretName
			}
		}
	}
}
