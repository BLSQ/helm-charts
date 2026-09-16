# chap

![Version: 1.1.1](https://img.shields.io/badge/Version-1.1.1-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: v2.1.0](https://img.shields.io/badge/AppVersion-v2.1.0-informational?style=flat-square)

CHAP (Climate Health Analysis Platform)

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| https://valkey.io/valkey-helm | valkey | 0.9.2 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| api.affinity | object | `{}` |  |
| api.command[0] | string | `"gunicorn"` |  |
| api.command[1] | string | `"-c"` |  |
| api.command[2] | string | `"gunicorn.conf.py"` |  |
| api.command[3] | string | `"-k"` |  |
| api.command[4] | string | `"uvicorn.workers.UvicornWorker"` |  |
| api.command[5] | string | `"chap_core.rest_api.app:app"` |  |
| api.command[6] | string | `"--bind"` |  |
| api.command[7] | string | `"0.0.0.0:8000"` |  |
| api.enabled | bool | `true` |  |
| api.image.pullPolicy | string | `"IfNotPresent"` |  |
| api.image.repository | string | `"ghcr.io/dhis2-chap/chap-core"` |  |
| api.image.tag | string | `""` | Defaults to the chart appVersion. |
| api.imagePullSecrets | list | `[]` |  |
| api.ingress.annotations | object | `{}` |  |
| api.ingress.className | string | `""` |  |
| api.ingress.enabled | bool | `false` |  |
| api.ingress.hosts[0].host | string | `"chart-example.local"` |  |
| api.ingress.hosts[0].paths[0].path | string | `"/"` |  |
| api.ingress.hosts[0].paths[0].pathType | string | `"ImplementationSpecific"` |  |
| api.ingress.tls | list | `[]` |  |
| api.labels | object | `{}` | Labels applied to the api resources and pods, on top of global.commonLabels. |
| api.livenessProbe.failureThreshold | int | `3` |  |
| api.livenessProbe.httpGet.path | string | `"/health"` |  |
| api.livenessProbe.httpGet.port | string | `"http"` |  |
| api.livenessProbe.initialDelaySeconds | int | `30` |  |
| api.livenessProbe.periodSeconds | int | `10` |  |
| api.livenessProbe.timeoutSeconds | int | `5` |  |
| api.nodeSelector | object | `{}` |  |
| api.podAnnotations | object | `{}` |  |
| api.podLabels | object | `{}` |  |
| api.podSecurityContext.fsGroup | int | `1000` |  |
| api.readinessProbe.failureThreshold | int | `3` |  |
| api.readinessProbe.httpGet.path | string | `"/health"` |  |
| api.readinessProbe.httpGet.port | string | `"http"` |  |
| api.readinessProbe.initialDelaySeconds | int | `10` |  |
| api.readinessProbe.periodSeconds | int | `5` |  |
| api.readinessProbe.timeoutSeconds | int | `3` |  |
| api.replicaCount | int | `1` |  |
| api.resources | object | `{}` |  |
| api.securityContext.capabilities.drop[0] | string | `"ALL"` |  |
| api.securityContext.readOnlyRootFilesystem | bool | `true` |  |
| api.securityContext.runAsGroup | int | `1000` |  |
| api.securityContext.runAsUser | int | `1000` |  |
| api.service.annotations | object | `{}` |  |
| api.service.type | string | `"ClusterIP"` |  |
| api.serviceAccount.annotations | object | `{}` |  |
| api.serviceAccount.automount | bool | `true` |  |
| api.serviceAccount.create | bool | `true` |  |
| api.serviceAccount.name | string | `""` |  |
| api.tolerations | list | `[]` |  |
| api.volumeMounts | list | `[]` |  |
| db.database | string | `"chap_core"` |  |
| db.enableSuperuserAccess | bool | `true` |  |
| db.enabled | bool | `true` |  |
| db.existingSecret | string | `""` | Existing secret with `username` and `password` keys, used as the CNPG superuser secret. |
| db.imageName | string | `""` |  |
| db.instances | int | `1` |  |
| db.labels | object | `{}` | Labels applied to the Cluster resource and, via CNPG inheritedMetadata, to everything the operator creates from it, on top of global.commonLabels. |
| db.monitoring.enabled | bool | `false` |  |
| db.password | string | `""` | Superuser password. Required unless existingSecret is set. |
| db.podLabels | object | `{}` | Labels applied via CNPG inheritedMetadata to all objects the operator creates (pods, PVCs, ...). |
| db.pooler.enabled | bool | `false` |  |
| db.storageSize | string | `"10Gi"` |  |
| db.version | string | `"17"` |  |
| dhis2.apiVersion | string | `"42"` |  |
| dhis2.enabled | bool | `false` |  |
| dhis2.hostname | string | `""` |  |
| dhis2.labels | object | `{}` | Labels applied to the registration job and its pod, on top of global.commonLabels. The job is the only evidence that registration happened, so a label is what lets something track it. |
| dhis2.password | string | `""` | Required when dhis2.enabled is true. |
| dhis2.registerJob.backoffLimit | int | `10` |  |
| dhis2.registerJob.ttlSecondsAfterFinished | int | `86400` | How long the finished job is kept. It is the record of whether registration succeeded, so it outlives the run by a day rather than the hour a job is usually worth keeping. |
| dhis2.registerJob.waitForDhis2TimeoutSeconds | int | `900` | How long the job waits for the DHIS 2 API to answer before giving up. The route POST is one shot per pod, so the job waits for DHIS 2 rather than burning backoffLimit attempts on a boot that has not finished. Covers a cold start with a large database. |
| dhis2.username | string | `"system"` |  |
| externalDatabase.database | string | `"chap_core"` |  |
| externalDatabase.existingSecret | string | `""` | Existing secret with the external database credentials. |
| externalDatabase.host | string | `""` |  |
| externalDatabase.password | string | `""` | Password for the external database. Ignored when existingSecret is set. |
| externalDatabase.port | int | `5432` |  |
| externalDatabase.secretKeys.password | string | `"password"` |  |
| externalDatabase.secretKeys.username | string | `"username"` |  |
| externalDatabase.username | string | `"postgres"` |  |
| externalValkey.existingSecret | string | `""` | Existing secret with the external Valkey password. |
| externalValkey.host | string | `""` |  |
| externalValkey.password | string | `""` | Password for the external Valkey. Ignored when existingSecret is set. |
| externalValkey.port | int | `6379` |  |
| externalValkey.secretKeys.password | string | `"password"` |  |
| fullnameOverride | string | `""` |  |
| global.commonLabels | object | `{}` | Labels applied to all resources and pods of every CHAP component (api, worker, db). The bundled valkey subchart does not read global values, so set valkey.commonLabels as well. Labels that differ per component belong in api.labels, worker.labels and db.labels. |
| nameOverride | string | `""` |  |
| valkey.auth.aclUsers.default | object | `{"permissions":"~* &* +@all"}` | The default user requires a `password`, unless auth.usersExistingSecret is set. |
| valkey.auth.enabled | bool | `true` |  |
| valkey.commonLabels | object | `{}` | Set to the same labels as global.commonLabels; the valkey subchart does not read global values. |
| valkey.dataStorage.enabled | bool | `true` |  |
| valkey.dataStorage.requestedSize | string | `"10Gi"` |  |
| valkey.enabled | bool | `true` |  |
| worker.affinity | object | `{}` |  |
| worker.command[0] | string | `"celery"` |  |
| worker.command[1] | string | `"-A"` |  |
| worker.command[2] | string | `"chap_core.rest_api.celery_tasks"` |  |
| worker.command[3] | string | `"worker"` |  |
| worker.command[4] | string | `"--loglevel=info"` |  |
| worker.enabled | bool | `true` |  |
| worker.image.pullPolicy | string | `"IfNotPresent"` |  |
| worker.image.repository | string | `"ghcr.io/dhis2-chap/chap-worker"` |  |
| worker.image.tag | string | `""` | Defaults to the chart appVersion. |
| worker.imagePullSecrets | list | `[]` |  |
| worker.labels | object | `{}` | Labels applied to the worker resources and pods, on top of global.commonLabels. |
| worker.livenessProbe.exec.command[0] | string | `"celery"` |  |
| worker.livenessProbe.exec.command[1] | string | `"-A"` |  |
| worker.livenessProbe.exec.command[2] | string | `"chap_core.rest_api.celery_tasks"` |  |
| worker.livenessProbe.exec.command[3] | string | `"inspect"` |  |
| worker.livenessProbe.exec.command[4] | string | `"ping"` |  |
| worker.livenessProbe.failureThreshold | int | `3` |  |
| worker.livenessProbe.initialDelaySeconds | int | `30` |  |
| worker.livenessProbe.periodSeconds | int | `10` |  |
| worker.livenessProbe.timeoutSeconds | int | `5` |  |
| worker.nodeSelector | object | `{}` |  |
| worker.podAnnotations | object | `{}` |  |
| worker.podLabels | object | `{}` |  |
| worker.podSecurityContext.fsGroup | int | `1000` |  |
| worker.readinessProbe.exec.command[0] | string | `"celery"` |  |
| worker.readinessProbe.exec.command[1] | string | `"-A"` |  |
| worker.readinessProbe.exec.command[2] | string | `"chap_core.rest_api.celery_tasks"` |  |
| worker.readinessProbe.exec.command[3] | string | `"inspect"` |  |
| worker.readinessProbe.exec.command[4] | string | `"ping"` |  |
| worker.readinessProbe.failureThreshold | int | `3` |  |
| worker.readinessProbe.initialDelaySeconds | int | `10` |  |
| worker.readinessProbe.periodSeconds | int | `30` |  |
| worker.readinessProbe.timeoutSeconds | int | `10` |  |
| worker.replicaCount | int | `1` |  |
| worker.resources | object | `{}` |  |
| worker.securityContext.capabilities.drop[0] | string | `"ALL"` |  |
| worker.securityContext.readOnlyRootFilesystem | bool | `true` |  |
| worker.securityContext.runAsGroup | int | `1000` |  |
| worker.securityContext.runAsUser | int | `1000` |  |
| worker.serviceAccount.annotations | object | `{}` |  |
| worker.serviceAccount.automount | bool | `true` |  |
| worker.serviceAccount.create | bool | `true` |  |
| worker.serviceAccount.name | string | `""` |  |
| worker.tolerations | list | `[]` |  |
| worker.volumeMounts | list | `[]` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)
