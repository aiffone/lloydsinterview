# demonstration

helm install prometheus prometheus-community
/kube-prometheus-stack -n monitoring

kubectl port-forward service/prometheus-grafana 8080:80 -n monitoring
