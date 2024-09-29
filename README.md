# demonstration

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts

helm install prometheus prometheus-community
/kube-prometheus-stack -n monitoring

kubectl port-forward service/prometheus-grafana 8081:80 -n monitoring
