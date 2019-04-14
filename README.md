# ansible_zlz
ansible playbooks

### rancher/:

以安装3个k8s节点，节点类型为[controlplane,worker,etcd]的k8s集群为例



方式一：以3个k8s节点之一兼作rke节点，从任意一台ansible主控机控制安装

此方式分发密钥过程不能自动完成



方式二：rke节点独立，不作k8s节点，并从rke节点执行ansible命令

1. 准备4个云主机

2. 以其中一个作为rke节点，并作为ansible主控机

   ```sh
   ssh-keygen
   ssh-copy-id root@127.0.0.1
   yum install ansible -y
   ```

3. 修改hosts中k8s节点信息

   将另外3个主机信息填入[k8s]

4. 修改hosts中[all:vars]

   主要是修改lb_dn、lb_ip，即负载均衡的域名、IP

5. 执行安装

```sh
ansible-playbook -i hosts roles/onekey2.yml
```

