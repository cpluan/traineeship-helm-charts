## Generate argocd tls secret:

```bash
NAMESPACE="argocd"
SECRET_NAME="${NAMESPACE}-server-tls-prd"
SECRET_FILE="tls-secret-encrypted.yaml"

# Relative/Absolute paths to the certificate files
# NOTE: The certificate file must contain the full chain!
CERT_FILE="deploy.svc.eurotux.pt.crt"
KEY_FILE="deploy.svc.eurotux.pt.key"

kubectl create secret tls --namespace="${NAMESPACE}" -o yaml --dry-run=client "${SECRET_NAME}" --cert "${CERT_FILE}" --key "${KEY_FILE}" | kubeseal -f=/dev/stdin --cert https://sealed-secrets.svc.eurotux.pt/v1/cert.pem -w "${SECRET_FILE}" --name "${SECRET_NAME}"
```


curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh"  | bash

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm install prometheus prometheus-community/kube-prometheus-stack --namespace monitoring --create-namespace


kubectl apply -f https://github.com/prometheus-operator/prometheus-operator/releases/latest/download/bundle.yaml


kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | base64 -d  