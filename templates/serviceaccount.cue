package templates

import (
	corev1 "k8s.io/api/core/v1"
)

#ServiceAccount: corev1.#ServiceAccount & {
	#config: #Config
	#config.serviceAccount
	apiVersion: "v1"
	kind:       "ServiceAccount"

	metadata: {
		name:      *#config.serviceAccount.metadata.name | #config.metadata.name
		namespace: #config.metadata.namespace
		labels:    #config.metadata.labels
		if #config.metadata.annotations != _|_ {
			annotations: (#config & #config.serviceAccount).metadata.annotations
		}
	}
}
