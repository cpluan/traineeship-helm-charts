# ArgoCD Kustomization

This repository contains the structure for managing the installation and configuration of ArgoCD using `Kustomize` with environment overlays and Helm value support.

## Structure

```
.
├── base                                            # Common base for all environments
│   ├── helm                                        # Helm Charts integration
│   │   ├── helm.yaml                               # Reference to the ArgoCD Helm Chart
│   │   ├── kustomization.yaml
│   │   └── values                                  # Helm values split by purpose
│   │       ├── helm-argocd-components.yaml
│   │       ├── helm-resources.yaml
│   │       └── helm.yaml
│   ├── kustomization.yaml                          # Base Kustomization
│   └── namespace.yaml                              # Namespace for ArgoCD
├── kustomization.yaml                              # Root Kustomization
├── overlays
│   └── prd                                         # Production environment overlay
│       ├── helm
│       │   ├── kustomization.yaml
│       │   └── values
│       │       └── helm-argocd-components.yaml
│       └── kustomization.yaml
├── resources
│   ├── argocd-prd-chart.yaml                       # Declarative HelmRelease resource
│   └── ingress.yaml                                # Ingress configuration for ArgoCD
```

## Usage

### 1. Prerequisites

- `kubectl`
- `kustomize` (v5+)
- A Kubernetes cluster with appropriate permissions
- ArgoCD (can be used to manage this repository itself)

### 2. Apply the Base Manually

```bash
kubectl apply -k base/
```

### 3. Apply the Production Overlay

```bash
kubectl apply -k overlays/prd/
```

### 4. Access ArgoCD

Retrieve the `admin` user password:

```bash
kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | base64 -d
```

Access the ArgoCD UI using the domain defined in the `ingress.yaml` file.

## Notes

- Helm values are split into separate files (`components`, `resources`, `global values`) for easier maintenance.
- This repository can be used directly as a source in an ArgoCD `Application` pointing to the `overlays/prd` path.