# AWX Operator - Kustomize Deployment

This repository provides a deployment setup for the AWX Operator using Kustomize and the `HelmChartInflationGenerator` plugin to manage the Helm chart installation.

## Directory Structure

```
.
├── base
│   ├── awx-instance.yaml              # Custom AWX resource definition
│   ├── helm
│   │   ├── helm.yaml                  # HelmChartInflationGenerator definition
│   │   ├── kustomization.yaml         # Kustomization for Helm resources
│   │   └── values
│   │       ├── helm-components.yaml   # Component-specific values
│   │       ├── helm-resources.yaml    # Resource requests and limits
│   │       └── helm.yaml              # General Helm values
│   ├── kustomization.yaml             # Combines namespace, helm, and instance
│   └── namespace.yaml                 # Namespace definition for AWX
├── kustomization.yaml                 # Root kustomization
├── resources
│   ├── awx-prd-chart.yaml             # Optional declarative chart resource (alternative to plugin)
│   └── ingress.yaml                   # Ingress configuration for AWX access
└── README.md
```

## Prerequisites

- `kubectl`
- `kustomize` (v5+)
- HelmChartInflationGenerator enabled in your `kustomize` setup
- A Kubernetes cluster with permissions to install CRDs
- Access to `https://ansible.github.io/awx-operator/` Helm repo

## Usage

### 1. Apply Base Configuration

```bash
kubectl apply -k base/
```

This will install:
- The AWX Operator using the Helm chart
- The AWX custom resource
- The namespace for AWX

### 2. (Optional) Apply Ingress Resources

```bash
kubectl apply -f resources/ingress.yaml
```

### 3. Access AWX

After deployment, wait for the `awx` pod to become ready. Then, access the service using the method configured in your ingress or service exposure.

## Notes

- `HelmChartInflationGenerator` automatically pulls and renders the AWX Operator chart using values in `helm/values/`.
- The AWX instance (`awx-instance.yaml`) defines service type, credentials, and hostname.
- You can also use `resources/awx-prd-chart.yaml` if managing with ArgoCD/FluxCD declarative Helm releases.


## Admin Access

To retrieve the default AWX admin password after deployment, run:

```bash
kubectl get secret awx-demo-admin-password -n awx -o jsonpath="{.data.password}" | base64 --decode
```

Then log in using the default username `admin` and the decoded password.