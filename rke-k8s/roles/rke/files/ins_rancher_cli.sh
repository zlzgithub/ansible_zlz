set -x

wget --no-check-certificate https://www.cnrancher.com/download/cli/rancher-linux-amd64.tar.gz -t 3 -T 15

mkdir rancher-linux-amd64.tmp.d # 临时目录

tar -xf rancher-linux-amd64.tar.gz -C rancher-linux-amd64.tmp.d

find rancher-linux-amd64.tmp.d -name 'rancher' -type f | xargs -I {} mv {} /usr/bin;

rm -rf rancher-linux-amd64.tmp.d
