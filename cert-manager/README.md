# Cert-Manager Deployment with Kustomize and Helm

This repository defines the deployment of Cert-Manager on Kubernetes using `kustomize`, with overlays for different issuers (`selfsigned`, `lego webhook`, `reflector`) and Helm Chart integration.

## Structure

```
.
├── apps
│   ├── cert-manager-chart.yaml         # Main cert-manager Application manifest
│   ├── cert-manager-lego.yaml          # Application for LEGO ACME issuer
│   ├── cert-manager-reflector.yaml     # Application for certificate reflector
│   └── cert-manager-selfsigned.yaml    # Application for self-signed certificate issuer
├── base
│   ├── helm
│   │   ├── helm.yaml                   # Helm repository and chart reference
│   │   ├── kustomization.yaml          # Kustomization for Helm chart
│   │   └── values
│   │       ├── helm-resources.yaml     # Custom resources requests/limits
│   │       └── helm.yaml               # General Helm values for cert-manager
│   ├── kustomization.yaml              # Combines all base resources
│   └── namespace.yaml                  # Namespace definition for cert-manager
├── overlays
│   ├── lego-webhook
│   │   ├── helm
│   │   │   ├── helm.yaml               # Helm chart reference for the webhook
│   │   │   ├── kustomization.yaml      # Kustomize file for combining resources
│   │   │   └── values
│   │   │       ├── helm-components.yaml # Component-specific Helm values
│   │   │       └── helm.yaml           # General values for the webhook
│   │   ├── issuer.yaml                 # LEGO issuer for ACME (Dev environment)
│   │   ├── kustomization.yaml          # Overlay Kustomization for lego-webhook
│   │   └── secret.yaml                 # Secret containing DNS credentials
│   ├── lego-webhook-prd
│   │   ├── helm
│   │   │   ├── helm.yaml               # Helm chart reference for the webhook
│   │   │   ├── kustomization.yaml      # Kustomize file for production webhook
│   │   │   └── values
│   │   │       ├── helm-components.yaml # Production component values
│   │   │       └── helm.yaml           # Production general Helm values
│   │   ├── issuer.yaml                 # LEGO issuer for ACME (Production)
│   │   ├── kustomization.yaml          # Overlay Kustomization for production
│   │   └── secret.yaml                 # Secret with DNS provider credentials
│   ├── reflector
│   │   ├── helm
│   │   │   ├── helm.yaml               # Helm chart reference for reflector
│   │   │   ├── kustomization.yaml      # Kustomize file for combining reflector components
│   │   │   └── values
│   │   │       ├── helm-components.yaml # Component values for reflector
│   │   │       ├── helm-resources.yaml  # Resource settings for reflector
│   │   │       └── helm.yaml           # General Helm values for reflector
│   │   ├── kustomization.yaml          # Overlay Kustomization for reflector
│   │   └── namespace.yaml              # Namespace for the reflector
│   └── selfsigned
│       ├── certificate.yaml            # Self-signed certificate definition
│       ├── issuer.yaml                 # Self-signed issuer definition
│       └── kustomization.yaml          # Overlay Kustomization for self-signed setup
├── kustomization.yaml                  # Root Kustomization file
└── README.md
```

## Prerequisites

- `kubectl`
- `kustomize` (v5+)
- `Helm`
- Kubernetes cluster with CRD creation permissions

## Usage

### 1. Apply the base:

```bash
kubectl apply -k base/
```

### 2. Choose and apply the desired overlay:

#### Self-Signed:

```bash
kubectl apply -k overlays/selfsigned/
```

#### Lego Webhook (Dev):

```bash
kubectl apply -k overlays/lego-webhook/
```

#### Lego Webhook (Prod):

```bash
kubectl apply -k overlays/lego-webhook-prd/
```

#### Reflector:

```bash
kubectl apply -k overlays/reflector/
```


## Notes

- Overlays are structured to maximize reuse from the base.
- Helm values are organized for easy tuning by component.
- The reflector helps synchronize TLS secrets across namespaces.