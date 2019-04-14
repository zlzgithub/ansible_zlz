set -x

helm_version=$1
lb_dn=$2
lb_ip=$3

if [ -z "${helm_version}" ]; then
  exit 1
fi

if [ -z "${lb_dn}" ]; then
  exit 2
fi

if [ -z "${lb_ip}" ]; then
  exit 3
fi

kubectl -n kube-system create serviceaccount tiller

kubectl create clusterrolebinding tiller --clusterrole cluster-admin --serviceaccount=kube-system:tiller

helm init --service-account tiller   --tiller-image registry.cn-hangzhou.aliyuncs.com/google_containers/tiller:${helm_version} --stable-repo-url https://kubernetes.oss-cn-hangzhou.aliyuncs.com/charts

helm repo add rancher-stable https://releases.rancher.com/server-charts/stable

sleep 30

helm install stable/cert-manager \
  --name cert-manager \
  --namespace kube-system

helm install rancher-stable/rancher \
  --name rancher \
  --namespace cattle-system \
  --set hostname=${lb_dn}

kubectl -n cattle-system patch deployments cattle-cluster-agent --patch '{
    "spec": {
        "template": {
            "spec": {
                "hostAliases": [
                    {
                        "hostnames":
                        [
                            "${lb_dn}"
                        ],
                            "ip": "${lb_ip}"
                    }
                ]
            }
        }
    }
}'

kubectl -n cattle-system patch daemonsets cattle-node-agent --patch '{
    "spec": {
        "template": {
            "spec": {
                "hostAliases": [
                    {
                        "hostnames":
                        [
                            "${lb_dn}"
                        ],
                            "ip": "${lb_ip}"
                    }
                ]
            }
        }
    }
}'

#
wget --no-check-certificate https://www.cnrancher.com/download/cli/rancher-linux-amd64.tar.gz -t 3 -T 15
mkdir rancher-linux-amd64.tmp.d # 临时目录
tar -xf rancher-linux-amd64.tar.gz -C rancher-linux-amd64.tmp.d
find rancher-linux-amd64.tmp.d -name 'rancher' -type f | xargs -I {} mv {} /usr/bin;
rm -rf rancher-linux-amd64.tmp.d

