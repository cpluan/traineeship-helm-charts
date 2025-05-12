# AWS Load Balancer Controller - Kustomize Deployment

This repository provides a structured setup to deploy the AWS Load Balancer Controller using `kustomize` and Helm integration, with support for overlay patches and externalized configuration.

## Directory Structure

```
.
├── base
│   ├── backup/                        # Optional backup customization
│   │   └── kustomization.yaml
│   ├── helm/                          # Helm chart configuration
│   │   ├── helm.yaml                  # HelmChartInflationGenerator or HelmRelease source
│   │   ├── kustomization.yaml         # Kustomization for Helm
│   │   └── values/
│   │       └── helm.yaml              # Helm values for the controller
│   ├── kustomization.yaml             # Base kustomization combining patches and Helm
│   └── patch-deployment.json          # JSON patch to inject cluster, VPC, and region dynamically
├── kustomization.yaml                 # Root kustomization
├── resources/
│   └── aws-lbc-chart.yaml             # Declarative HelmRelease resource (alternative to generator)
└── README.md
```

## Prerequisites

- `kubectl`
- `kustomize` v5+ with support for Helm plugins
- A Kubernetes cluster (typically EKS)
- IAM permissions and OIDC provider configured for LBC
- Helm chart repo: [https://github.com/aws/eks-charts](https://github.com/aws/eks-charts)

## Usage

### 1. Configure AWS region and VPC via ConfigMap

Before applying, make sure a `ConfigMap` exists:

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: aws-data-config
  namespace: kube-system
data:
  aws-region: us-east-1
  vpc-id: vpc-xxxxxxxx
```

### 2. Apply base configuration

```bash
kubectl apply -k base/
```

### 3. Optional: Apply additional overlays or custom resources

```bash
kubectl apply -f resources/aws-lbc-chart.yaml
```

## Patch Behavior

The deployment is dynamically patched using a JSON patch (`patch-deployment.json`) which:
- Replaces the container args to inject the cluster name, region and VPC
- Adds environment variables from a `ConfigMap`

These values are evaluated at runtime by Kubernetes using the config keys.

## Notes

- Helm values are modularized under `helm/values/`
- The deployment assumes a valid OIDC + IAM Role setup for the controller