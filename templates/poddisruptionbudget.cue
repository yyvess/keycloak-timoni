package templates

import (
	policyv1 "k8s.io/api/policy/v1"
)

#PodDisruptionBudget: policyv1.#PodDisruptionBudget & {
	apiVersion: "policy/v1"
	kind:       "PodDisruptionBudget"
	#config:    #Config
	metadata:   #config.metadata
	spec: #config.pdb.spec & {
		selector: {
			matchLabels: {
				#config.selector.labels
			}}
	}
}
