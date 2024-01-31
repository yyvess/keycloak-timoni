package templates

import (
	corev1 "k8s.io/api/core/v1"
)

#PersistentVolumeClaim: corev1.#PersistentVolumeClaim & {
	#config:    #Config
	apiVersion: "v1"
	kind:       "PersistentVolumeClaim"

	metadata: #config.metadata
	spec: {
		volumeMode: "Filesystem"
		accessModes: ["ReadWriteOnce"]
		storageClassName: #config.pvc.storageClassName
		resources: {
			requests: {
				storage: #config.pvc.size
			}
		}
	}
}
