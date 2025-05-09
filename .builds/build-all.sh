#!/bin/bash

set -euo pipefail

BUILD_DIR="."
BIN_KUSTOMIZE="../bin/kustomize"
BIN_HELM="../bin/helm"

mkdir -p "$BUILD_DIR"

# ArgoCD
echo "🔧 Building argocd..."
$BIN_KUSTOMIZE build \
  --enable-helm \
  --helm-command "$BIN_HELM" \
  argocd/overlays/prd > "$BUILD_DIR/argocd.yaml"
$BIN_KUSTOMIZE build \
  --enable-helm \
  --helm-command "$BIN_HELM" \
  argocd/overlays/prd > "$BUILD_DIR/argocd.yaml"
echo "✅ argocd.yaml gerado"

# AWX
echo "🔧 Building awx..."
$BIN_KUSTOMIZE build \
  --enable-helm \
  --helm-command "$BIN_HELM" \
  awx/base > "$BUILD_DIR/awx.yaml"
echo "✅ awx.yaml gerado"

# AWS EBS CSI
echo "🔧 Building aws-ebs-csi..."
$BIN_KUSTOMIZE build \
  --enable-helm \
  --helm-command "$BIN_HELM" \
  aws-ebs-csi/base > "$BUILD_DIR/aws-ebs-csi.yaml"
echo "✅ aws-ebs-csi.yaml gerado"

# AWS LB Controller
echo "🔧 Building aws-lb-controller..."
$BIN_KUSTOMIZE build \
  --enable-helm \
  --helm-command "$BIN_HELM" \
  aws-lb-controller/base > "$BUILD_DIR/aws-lb-controller.yaml"
echo "✅ aws-lb-controller.yaml gerado"

# cert-manager
echo "🔧 Building cert-manager..."
$BIN_KUSTOMIZE build \
  --enable-helm \
  --helm-command "$BIN_HELM" \
  cert-manager/base > "$BUILD_DIR/cert-manager.yaml"
echo "✅ cert-manager.yaml gerado"

# generic
echo "🔧 Building generic..."
$BIN_KUSTOMIZE build \
  --enable-helm \
  --helm-command "$BIN_HELM" \
  generic/overlays/prd > "$BUILD_DIR/generic.yaml"
echo "✅ generic.yaml gerado"

# ingress-elb
echo "🔧 Building ingress-elb..."
$BIN_KUSTOMIZE build \
  --enable-helm \
  --helm-command "$BIN_HELM" \
  ingress-elb/base > "$BUILD_DIR/ingress-elb.yaml"
echo "✅ ingress-elb.yaml gerado"

# kube-prometheus-stack
echo "🔧 Building kube-prometheus-stack..."
$BIN_KUSTOMIZE build \
  --enable-helm \
  --helm-command "$BIN_HELM" \
  kube-prometheus-stack/overlays/prd > "$BUILD_DIR/kube-prometheus-stack.yaml"
echo "✅ kube-prometheus-stack.yaml gerado"

# rancher
echo "🔧 Building rancher..."
$BIN_KUSTOMIZE build \
  --enable-helm \
  --helm-command "$BIN_HELM" \
  rancher/overlays/prd > "$BUILD_DIR/rancher.yaml"
echo "✅ rancher.yaml gerado"

# local-path (sem Helm)
echo "🔧 Building local-path..."
$BIN_KUSTOMIZE build local-path > "$BUILD_DIR/local-path.yaml"
echo "✅ local-path.yaml gerado"

echo "🟢 Todos os builds foram concluídos com sucesso!"
