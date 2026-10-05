# OpenRig DevOps Configuration

This repository contains DevOps engineer configurations and Helm charts for implementing a comprehensive observability stack and GitOps pipeline.

## Overview

As a DevOps Engineer in the OpenRig team, I've implemented the following components:

### Phase 1: Task 1 (Loki + Promtail) & Task 3 (Helm Charts)
- **Loki Stack**: Centralized logging with Grafana Loki, Promtail, and Grafana
- **Helm Charts**: Standardized Helm chart patterns for applications
- **ArgoCD**: GitOps continuous delivery system
- **CI/CD Pipeline**: GitHub Actions workflow for build, test, security scan, and deploy

### Phase 2: Task 2a (Tempo Infrastructure) & Task 4 (HPA, CronJob, NetworkPolicy)
- **Tempo Stack**: Distributed tracing with Grafana Tempo and OpenTelemetry Collector
- **Application Chart**: Standardized application Helm chart with HPA, CronJob, and NetworkPolicy

### Phase 3: Task 5 (CI/CD + ArgoCD)
- Integrated CI/CD with ArgoCD for automated deployments

## Directory Structure

```
charts/
├── loki/              # Loki stack (logging) Helm chart
├── tempo/             # Tempo stack (tracing) Helm chart
├── application/       # Standardized application Helm chart
├── argo-cd/           # ArgoCD GitOps Helm chart
└── ci-cd/             # CI/CD pipeline configuration

argocd/
├── applications/      # ArgoCD Application definitions
└── applicationset.yaml # ArgoCD ApplicationSet for microservices

.github/
└── workflows/
    └── ci-cd.yaml     # GitHub Actions CI/CD pipeline
```

## Loki Stack Features

- **Logging**: Grafana Loki with Promtail agent for log collection
- **Visualization**: Grafana dashboard for log analysis
- **Monitoring**: ServiceMonitor and PodMonitor for Prometheus scraping
- **Alerting**: PrometheusRule for Loki-specific alerts
- **Security**: Pod Security Admission, NetworkPolicy, resource limits
- **Persistence**: Configurable persistent storage for Loki chunks
- **Scalability**: Simple-scalable deployment mode for production

## Tempo Stack Features

- **Tracing**: Grafana Tempo with OpenTelemetry Collector
- **Protocols**: OTLP, Jaeger, Zipkin receiver support
- **Monitoring**: ServiceMonitor and PodMonitor for Prometheus scraping
- **Alerting**: PrometheusRule for Tempo-specific alerts
- **Security**: Pod Security Admission, NetworkPolicy, resource limits
- **Persistence**: Configurable persistent storage for Tempo traces
- **Components**: Distributed deployment (tempo, query-frontend, querier, compactor)

## Application Chart Features

- **Standardization**: Consistent patterns for Deployments, Services, HPA, etc.
- **Best Practices**: Resource limits, probes, security contexts, topology spread
- **Extensibility**: Supports CronJobs, Ingress, NetworkPolicy, ServiceMonitor
- **Observability**: Built-in ServiceMonitor for Prometheus metrics
- **Security**: NetworkPolicy with default-deny posture, pod security standards

## ArgoCD Features

- **GitOps**: Declarative, version-controlled application deployments
- **Security**: Pod Security Admission, NetworkPolicy, resource limits
- **Monitoring**: ServiceMonitor for Prometheus scraping
- **Alerting**: PrometheusRule for ArgoCD-specific alerts
- **High Availability**: Multiple replicas for server, repo-server, application-controller
- **Authentication**: Dex integration for OIDC (GitHub, etc.)
- **Storage**: Redis for session storage and caching

## CI/CD Pipeline Features

- **Build**: Docker image building with multi-platform support
- **Test**: Unit, integration, and E2E testing with coverage reporting
- **Security**: SAST (CodeQL), SCA (Dependabot), container scanning (Trivy), IaC scanning (Checkov), secret scanning (TruffleHog)
- **Deploy**: ArgoCD-based deployments to development, staging, and production
- **Notifications**: Slack, email, and GitHub notifications for pipeline events
- **Environment Management**: Separate environments with approval gates

## Usage

### Install Loki Stack
```bash
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update
helm install loki-stack ./charts/loki --namespace logging --create-namespace
```

### Install Tempo Stack
```bash
helm install tempo-stack ./charts/tempo --namespace tracing --create-namespace
```

### Install Application Chart (example)
```bash
helm install my-app ./charts/application \
  --namespace production \
  --set deployment.image.repository=ghcr.io/org/my-app \
  --set deployment.image.tag=v1.0.0 \
  --set deployment.replicaCount=3
```

### Install ArgoCD
```bash
kubectl create namespace argocd
helm install argocd ./charts/argo-cd --namespace argocd
```

### Deploy Applications via ArgoCD
```bash
# Apply Application manifests
kubectl apply -f argocd/applications/

# Or use ApplicationSet for microservices
kubectl apply -f argocd/applicationset.yaml
```

## Security Considerations

All charts implement security best practices:
- Pod Security Admission "restricted" profile enforced
- Non-root containers with read-only root filesystems
- Dropped Linux capabilities
- Resource limits and requests defined
- NetworkPolicy with default-deny posture
- Service accounts with limited permissions
- Secrets management via Kubernetes secrets
- Image vulnerability scanning in CI/CD pipeline

## Observability Features

Each stack includes:
- **Metrics**: Prometheus endpoints scraped via ServiceMonitor/PodMonitor
- **Logs**: Structured JSON logging to stdout
- **Traces**: OpenTelemetry instrumentation with context propagation
- **Alerts**: Symptom-based alerts with runbook URLs
- **Dashboards**: Pre-configured Grafana dashboards (where applicable)

## Next Steps

1. Configure secrets for external integrations (GitHub, Slack, email, etc.)
2. Customize values.yaml files for your environment
3. Set up external object storage for Loki and Tempo (S3, GCS, Azure Blob)
4. Configure Alertmanager for alert routing
5. Set up log retention policies and storage cleanup
6. Implement RBAC for team access control
7. Add backup and disaster recovery procedures