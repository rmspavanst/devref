
Master and worker node:
------------------------

hostnamectl set-hostname worker-node-1
vi /etc/hosts
ping master-node
sudo yum install -y yum-utils
ip addr
reboot
yum install lsof git curl wget net-tools -y
hostnamectl set-hostname kube-master

vi /etc/fstab (commentout the swap)
swapoff -a

firewall-cmd --permanent --add-port=6443/tcp
firewall-cmd --permanent --add-port=10250/tcp
systemctl status firewalld
sudo firewall-cmd --reload


cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf 
net.bridge.bridge-nf-call-ip6tables = 1 
net.bridge.bridge-nf-call-iptables = 1 
EOF
sysctl --system


cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo 
[kubernetes] 
name=Kubernetes 
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-\$basearch 
enabled=1 
gpgcheck=1 
repo_gpgcheck=1 
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg 
exclude=kubelet kubeadm kubectl 
EOF


setenforce 0 

sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config

sestatus

yum install -y yum-utils device-mapper-persistent-data lvm2

yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo 
yum update -y && yum install containerd.io docker-ce docker-ce-cli


mkdir /etc/docker 
cat > /etc/docker/daemon.json <<EOF 
{ 
  "exec-opts": ["native.cgroupdriver=systemd"], 
  "log-driver": "json-file", 
  "log-opts": { 
    "max-size": "100m" 
  }, 
  "storage-driver": "overlay2", 
  "storage-opts": [ 
    "overlay2.override_kernel_check=true" 
  ] 
} 
EOF


mkdir -p /etc/systemd/system/docker.service.d 
systemctl daemon-reload 
systemctl restart docker 
systemctl enable docker


yum install -y kubelet kubeadm kubectl --disableexcludes=kubernetes 

echo 'KUBELET_EXTRA_ARGS="--fail-swap-on=false"' > /etc/sysconfig/kubelet
systemctl enable --now kubelet

cat /etc/sysconfig/network-scripts/ifcfg-enp0s3


In Master node:
----------------

kubeadm init --pod-network-cidr 10.244.0.0/16 --apiserver-advertise-address=192.168.0.157 (change to master ip)

watch docker images


mkdir -p $HOME/ .kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

## to create network
kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"


kubeadm join 192.168.0.120:6443 --token 77h1ak.dkb8iu8lvwb3btrg --discovery-token-ca-cert-hash sha256:fe300860ee55a41082aa068d874d876dcb3e596318d604baf898b16ce9ef7c92


In Worker Node:
-----------------



kubeadm join 192.168.0.157:6443 --token ycu5yd.att8mgqyf8qg9w44 --discovery-token-ca-cert-hash sha256:b2e9753ab8b2672cc8bfd75437f024b1289c4bcee28c001f780fae4a30812fdb


[ERROR CRI]: container runtime is not running

rm /etc/containerd/config.toml
systemctl restart containerd


kubectl label node <node name> node-role.kubernetes.io/<role name>=<key - (any name)>



