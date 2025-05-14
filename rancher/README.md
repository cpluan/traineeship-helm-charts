# Rancher - Kustomize Deployment with HelmChartInflationGenerator

This repository sets up Rancher using Kustomize with Helm chart integration and environment overlays, suitable for production deployments.

## Directory Structure

```
.
├── base
│   ├── helm/
│   │   ├── helm.yaml                       # HelmChartInflationGenerator definition
│   │   ├── kustomization.yaml              # Base kustomization for Helm chart
│   │   └── values/
│   │       ├── helm-components.yaml        # Component-specific settings
│   │       ├── helm-resources.yaml         # Resource limits and requests
│   │       └── helm.yaml                   # General Helm values
│   └── kustomization.yaml                  # Combines base components
├── overlays/
│   └── prd/
│       ├── helm/
│       │   ├── kustomization.yaml          # Production-specific Helm customization
│       │   └── values/
│       │       └── helm-components.yaml
│       └── kustomization.yaml              # Production overlay including namespace and ingress
├── resources/
│   ├── ingress.yaml                        # Ingress configuration for Rancher UI
│   ├── namespace.yaml                      # Namespace definition for Rancher
│   └── rancher-prd-chart.yaml              # Optional declarative HelmRelease for production
├── kustomization.yaml                      # Root kustomization
└── README.md
```

## Prerequisites

- `kubectl`
- `kustomize` v5+ with Helm plugin support
- Kubernetes cluster with Ingress controller and TLS setup (e.g., cert-manager)
- Helm chart repo: [https://charts.rancher.io](https://charts.rancher.io)

## Usage

### 1. Apply the base configuration

```bash
kubectl apply -k base/
```

### 2. Apply the production overlay

```bash
kubectl apply -k overlays/prd/
```

### 3. Retrieve the initial Rancher admin password

```bash
kubectl get secret --namespace cattle-system bootstrap-secret -o go-template='{{.data.bootstrapPassword|base64decode}}{{"\n"}}'
```

### 4. Access the Rancher UI

Access Rancher using the domain configured in the `ingress.yaml` and log in with username `admin` and the password retrieved above.

## Notes

- Helm values are modularized and layered between base and overlay.
- The `rancher-prd-chart.yaml` may be used as an alternative declarative installation for ArgoCD or Flux.
- Ensure DNS and TLS are properly configured before exposing the Rancher UI.