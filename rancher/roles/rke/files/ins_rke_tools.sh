set -x

helm_version=$1

if [ -z "${helm_version}" ]; then
  exit 1
fi

# https://www.cnrancher.com/download/rke/rke_linux-amd64
wget --no-check-certificate https://www.cnrancher.com/download/rke/rke_linux-amd64 -t 3 -T 15
chmod +x rke_linux-amd64
mv rke_linux-amd64 /usr/bin/rke

sleep 1
# https://www.cnrancher.com/download/kubectl/kubectl_amd64-linux
wget --no-check-certificate https://www.cnrancher.com/download/kubectl/kubectl_amd64-linux -t 3 -T 15
chmod +x kubectl_amd64-linux
mv kubectl_amd64-linux /usr/bin/kubectl

sleep 1
# https://www.cnrancher.com/download/helm/helm-linux.tar.gz
wget --no-check-certificate https://storage.googleapis.com/kubernetes-helm/helm-${helm_version}-linux-amd64.tar.gz -t 3 -T 15
tar -xf helm-${helm_version}-linux-amd64.tar.gz
mv linux-amd64/{helm,tiller} /usr/bin/
rm -rf linux-amd64

