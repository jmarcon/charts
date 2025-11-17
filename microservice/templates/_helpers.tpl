{{/*
Expand the name of the chart.
*/}}
{{- define "microservice.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "microservice.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "microservice.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create the name of the service to use
*/}}
{{- define "microservice.serviceName" -}}
{{- if .Values.service.name }}
{{- .Values.service.name | trunc 63 | trimSuffix "-"}}
{{- else }}
{{- include "microservice.fullname" . }}
{{- end }}
{{- end }}

{{/*
Common labels (includes version-dependent labels - use for Pod templates)
*/}}
{{- define "microservice.labels" -}}
service: {{ include "microservice.serviceName" . }}
env: {{ .Values.environment }}
helm.sh/chart: {{ include "microservice.chart" . }}
{{ include "microservice.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Metadata labels (stable labels without versions - use for resource metadata to avoid SSA conflicts)
*/}}
{{- define "microservice.metadataLabels" -}}
service: {{ include "microservice.serviceName" . }}
env: {{ .Values.environment }}
{{ include "microservice.selectorLabels" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "microservice.selectorLabels" -}}
app.kubernetes.io/name: {{ include "microservice.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "microservice.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "microservice.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create a list of volumes based on .Values.volumes and .Values.sharedDataProtectionVolume
*/}}
{{- define "microservice.volumes" -}}
{{- $volumes := list -}}
{{- if kindIs "slice" .Values.volumes -}}
{{- $volumes = .Values.volumes -}}
{{- end -}}
{{- if .Values.sharedDataProtectionVolume.enabled -}}
{{- $volume := dict "name" (default (include "microservice.fullname" .) .Values.sharedDataProtectionVolume.name) "persistentVolumeClaim" (dict "claimName" .Values.sharedDataProtectionVolume.claimName) -}}
{{- $volumes = append $volumes $volume -}}
{{- end -}}
{{- if $volumes -}}
{{- toYaml $volumes -}}
{{- end -}}
{{- end }}


{{/*
Create a list of VolumeMounts based on .Values.volumes and .Values.sharedDataProtectionVolume
*/}}
{{- define "microservice.volumeMounts" -}}
{{- $volumeMounts := list -}}
{{- if kindIs "slice" .Values.volumeMounts -}}
{{- $volumeMounts = .Values.volumeMounts -}}
{{- end -}}
{{- if .Values.sharedDataProtectionVolume.enabled -}}
{{- $volumeMount := dict "mountPath" "/data" "name" (default (include "microservice.fullname" .) .Values.sharedDataProtectionVolume.name) -}}
{{- $volumeMounts = append $volumeMounts $volumeMount -}}
{{- end -}}
{{- if $volumeMounts -}}
{{- toYaml $volumeMounts -}}
{{- end -}}
{{- end}}