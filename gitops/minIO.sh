# Add the MinIO Operator Helm repo
helm repo add minio https://operator.min.io/
helm repo update

# Install the MinIO Operator
helm install minio-operator minio/operator \
  --namespace minio-operator \
  --create-namespace \
  --version 5.0.18  # Pin the version for stability

#I1221 08:44:26.127816   23247 warnings.go:110] "Warning: unrecognized format \"int64\""
#I1221 08:44:26.207070   23247 warnings.go:110] "Warning: unrecognized format \"int32\""
#I1221 08:44:26.207090   23247 warnings.go:110] "Warning: unrecognized format \"int64\""
#NAME: minio-operator
#LAST DEPLOYED: Sun Dec 21 08:44:25 2025
#NAMESPACE: minio-operator
#STATUS: deployed
#REVISION: 1
#TEST SUITE: None
#NOTES:
#1. Get the JWT for logging in to the console:
#kubectl apply -f - <<EOF
#apiVersion: v1
#kind: Secret
#metadata:
#  name: console-sa-secret
#  namespace: minio-operator
#  annotations:
#    kubernetes.io/service-account.name: console-sa
#type: kubernetes.io/service-account-token
#EOF
#kubectl -n minio-operator get secret console-sa-secret -o jsonpath="{.data.token}" | base64 --decode
#
#2. Get the Operator Console URL by running these commands:
#  kubectl --namespace minio-operator port-forward svc/console 9090:9090
#  echo "Visit the Operator Console at http://127.0.0.1:9090"

kubectl create namespace minio-terraform-state

