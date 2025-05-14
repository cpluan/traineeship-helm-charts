# EBS CSI Driver - Kustomize Deployment

This repository defines the deployment of the EBS CSI (Container Storage Interface) driver using `kustomize` with Helm chart support. It enables the creation of StorageClasses and dynamic provisioning of EBS volumes in the Kubernetes cluster.

## Structure

```
.
├── base                                # Reusable base components
│   ├── helm                            # Helm chart for the EBS CSI driver
│   │   ├── helm.yaml
│   │   ├── kustomization.yaml
│   │   └── values                      # Values split for customization
│   │       ├── helm-components.yaml
│   │       └── helm-resources.yaml
│   └── kustomization.yaml              # Combines Helm resources
├── kustomization.yaml                  # Root kustomization
├── resources                           # Additional declarative resources
│   ├── aws-ebs-csi-chart.yaml
│   └── storageclass-ebs.yaml
├── README.md
```

## Prerequisites

- `kubectl`
- `kustomize` (v5+)
- Administrative permissions on the Kubernetes cluster
- EBS CSI Driver enabled in the AWS account (usually enabled by default on EKS clusters)

## Usage

### 1. Apply base resources:

```bash
kubectl apply -k base/
```

### 2. Apply additional resources:

```bash
kubectl apply -f resources/aws-ebs-csi-chart.yaml
kubectl apply -f resources/storageclass-ebs.yaml
```

### 3. Verify driver creation:

```bash
kubectl get pods -n kube-system -l app.kubernetes.io/name=aws-ebs-csi-driver
```

### 4. Verify created StorageClass:

```bash
kubectl get storageclass
```

## Notes

- The Helm value files (`helm-components.yaml`, `helm-resources.yaml`) allow customization of components and resource limits.
- The `storageclass-ebs.yaml` defines a default StorageClass with `volumeBindingMode: WaitForFirstConsumer`, which is ideal for multi-AZ clusters.