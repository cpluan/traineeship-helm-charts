# NGINX Ingress Controller with AWS NLB - Kustomize & Helm Deployment

This repository contains a structured setup for deploying the NGINX Ingress Controller using Helm via Kustomize, and integrating it with AWS NLB using additional Jobs and RBAC configuration.

## Directory Structure

```
.
├── apps/
│   ├── nginx-ingress-app.yaml         # ArgoCD Application manifest for ingress
│   ├── nlb-ingress-hosts.yaml         # ArgoCD Application for external host config
│   └── nlb-ingress-job.yaml           # ArgoCD Application for creating NLB job
├── base/
│   ├── helm/
│   │   ├── helm.yaml                  # HelmChartInflationGenerator config
│   │   ├── kustomization.yaml
│   │   └── values/
│   │       ├── helm-components.yaml   # Component-level configuration
│   │       └── helm-resources.yaml    # Resource requests and limits
│   ├── kustomization.yaml
│   └── namespace.yaml                 # Namespace for the ingress controller
├── ingress/
│   ├── hubble-ingress.yaml            # Ingress resource to expose Hubble UI
│   └── kustomization.yaml
├── jobs/
│   ├── create-nlb-service-job.yaml    # Kubernetes Job to configure AWS NLB manually
│   └── kustomization.yaml
├── resources/
│   ├── namespace.yaml                 # Additional namespace (if needed)
│   └── rbac.yaml                      # RBAC permissions for the NLB job
├── kustomization.yaml                 # Root kustomization
└── README.md
```

## Prerequisites

- `kubectl`
- `kustomize` v5+ with Helm plugin support
- Kubernetes cluster (e.g., EKS) with proper IAM roles for service accounts
- AWS Load Balancer Controller (if needed for annotations)
- ArgoCD (optional, for `apps/` deployment)

## Usage

### 1. Apply the base configuration

```bash
kubectl apply -k base/
```

### 2. Apply ingress configuration

```bash
kubectl apply -k ingress/
```

### 3. Apply RBAC and NLB provisioning job

```bash
kubectl apply -k jobs/
```

### 4. Apply additional resources (if not embedded in overlays)

```bash
kubectl apply -f resources/rbac.yaml
```

## Notes

- The `apps/` directory includes ArgoCD applications for managing components declaratively.
- The `create-nlb-service-job.yaml` is useful for explicitly provisioning AWS Network Load Balancers outside the Helm chart.
- Ingress annotations should match your AWS and NLB setup requirements.

