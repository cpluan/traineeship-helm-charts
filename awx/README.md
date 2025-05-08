# AWX Kustomization

❯ kubectl get secret awx-demo-admin-password -n awx -o jsonpath="{.data.password}" | base64 --decode