package templates

import (
	v1 "cert-manager.io/certificate/v1"
	issuerv1 "cert-manager.io/issuer/v1"
	timoniv1 "timoni.sh/core/v1alpha1"
)

#Certificate: v1.#Certificate & {
	#config:  #Config
	metadata: #config.metadata
	spec: #config.certificate.spec & {
		issuerRef: {
			group: "cert-manager.io"
			kind:  "Issuer"
		}
	}
}

#JksSecret: timoniv1.#ImmutableConfig & {
	#config: #Config
	#Kind:   timoniv1.#SecretKind
	#Meta: {
		name:        "\(#config.metadata.name)-jks-pwd"
		#Version:    #config.moduleVersion
		namespace:   #config.metadata.namespace
		annotations: #config.metadata.annotations
	}
	#Data: {
		// it's fine, secret don't add any security here
		// TODO Next version of cert manager, a pwd will be set by default
		// https://github.com/cert-manager/cert-manager/pull/6657
		// then we can remove this secret and use the default
		"password-jks": "changeit" // it's fine, secret don't add any security here
	}
}

#JKS: v1.#Certificate & {
	#config:     #Config
	#secretName: string
	metadata: timoniv1.#MetaComponent & {
		#Meta:      #config.metadata
		#Component: "jks"
	}
	spec: #config.jks.spec & {
		issuerRef: {
			group: "cert-manager.io"
			kind:  "Issuer"
		}
		keystores: {
			jks: {
				create: true
				passwordSecretRef: {
					key:  "password-jks"
					name: #secretName
				}
			}
		}
	}
}

#Issuer: issuerv1.#Issuer & {
	#config:  #Config
	metadata: #config.metadata
	spec:     #config.issuer.spec
}
