{{- define "product-catalog.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "product-catalog.fullname" -}}
{{- printf "%s-%s" .Release.Name (include "product-catalog.name" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "product-catalog.labels" -}}
app.kubernetes.io/name: {{ include "product-catalog.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/version: {{ .Values.appVersion | quote }}
harness.io/environment: {{ .Values.environment }}
{{- end -}}

{{- define "product-catalog.selectorLabels" -}}
app.kubernetes.io/name: {{ include "product-catalog.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{- define "product-catalog.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
{{- default (include "product-catalog.fullname" .) .Values.serviceAccount.name -}}
{{- else -}}
{{- default "default" .Values.serviceAccount.name -}}
{{- end -}}
{{- end -}}
