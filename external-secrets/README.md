# External Secrets - Kustomize Deployment with HelmChartInflationGenerator

This repository contains a structured setup for deploying [External Secrets Operator](https://external-secrets.io) using `kustomize` with Helm integration, resource overlays, and ArgoCD application manifests.

## Directory Structure

```
.
├── apps/
│   ├── external-secrets-prd-chart.yaml      # ArgoCD Application to deploy Helm chart
│   └── external-secrets-prd-resources.yaml  # ArgoCD Application to deploy static resources
├── base/
│   ├── helm/
│   │   ├── helm.yaml                        # HelmChartInflationGenerator definition
│   │   ├── kustomization.yaml               # Kustomization for Helm chart
│   │   └── values/
│   │       ├── helm-components.yaml         # Helm values specific to components
│   │       ├── helm-resources.yaml          # CPU/memory resources
│   │       └── helm.yaml                    # General Helm values
│   ├── kustomization.yaml                   # Combines base namespace and helm
│   └── namespace.yaml                       # Namespace for the operator
├── resources/
│   ├── ecr-token-generator.yaml             # CronJob or Job to generate ECR tokens
│   ├── external-pull-secret.yaml            # Docker registry pull secret
│   ├── kustomization.yaml                   # Combines resource files
│   └── secret-store.yaml                    # SecretStore CRD used by ESO
├── kustomization.yaml                       # Root kustomization
└── README.md
```

## Prerequisites

- Kubernetes cluster (e.g., EKS, GKE, etc.)
- `kubectl`
- `kustomize` v5+ with Helm plugin support
- Secret backend configured (e.g., AWS Secrets Manager, SSM)
- External Secrets Operator chart repo: `https://charts.external-secrets.io`

## Usage

### 1. Deploy Helm-based External Secrets Operator

```bash
kubectl apply -k base/
```

### 2. Apply resource definitions (SecretStore, CronJob, etc.)

```bash
kubectl apply -k resources/
```

### 3. Optionally use ArgoCD to manage both Helm chart and resources

```bash
kubectl apply -f apps/external-secrets-prd-chart.yaml
kubectl apply -f apps/external-secrets-prd-resources.yaml
```

## Notes

- The `ecr-token-generator.yaml` may be used to create a periodic Job or CronJob that refreshes a token and writes to a secret consumed by Kubernetes.
- The `external-pull-secret.yaml` is typically used to authenticate to private registries like AWS ECR.
- The `secret-store.yaml` defines the connection to your cloud secret provider.