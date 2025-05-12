# Kube Prometheus Stack - Kustomize Deployment with HelmChartInflationGenerator

This repository provides a Kustomize-based deployment structure for the kube-prometheus-stack Helm chart, supporting base overlays, production values, and ingress configuration.

## Directory Structure

```
.
├── base
│   ├── helm/
│   │   ├── helm.yaml                          # HelmChartInflationGenerator config
│   │   ├── kustomization.yaml                 # Base kustomization for Helm chart
│   │   └── values/
│   │       ├── helm-kb-prometheus-stk-components.yaml # Component-specific config
│   │       ├── helm-resources.yaml            # Resource limits and requests
│   │       └── helm.yaml                      # General Helm values
│   ├── kustomization.yaml                     # Combines namespace and Helm
│   └── namespace.yaml                         # Namespace for prometheus stack
├── overlays/
│   └── prd/
│       ├── helm/
│       │   ├── kustomization.yaml             # Overlay customization
│       │   └── values/
│       │       └── helm-components.yaml       # Production components config
│       └── kustomization.yaml                 # Includes ingress and overlayed values
├── resources/
│   ├── ingress.yaml                           # Ingress config to expose services
│   └── prometheus-stack-prd-chart.yaml        # Declarative HelmRelease (optional)
├── kustomization.yaml                         # Root kustomization
└── README.md
```

## Prerequisites

- `kubectl`
- `kustomize` (v5+) with Helm plugin support
- A Kubernetes cluster with access to internet and configured storage class
- Helm chart repo: [https://prometheus-community.github.io/helm-charts](https://prometheus-community.github.io/helm-charts)

## Usage

### 1. Apply the base layer

```bash
kubectl apply -k base/
```

### 2. Apply the production overlay

```bash
kubectl apply -k overlays/prd/
```

### 3. Optional: Apply ingress or chart resources separately

```bash
kubectl apply -f resources/ingress.yaml
kubectl apply -f resources/prometheus-stack-prd-chart.yaml
```

## Notes

- The `values/` directory is modular to separate component tuning and resource policies.
- The `HelmChartInflationGenerator` approach allows dynamic generation without committing rendered manifests.
- Use `prometheus-stack-prd-chart.yaml` if integrating with GitOps tools like ArgoCD or FluxCD.