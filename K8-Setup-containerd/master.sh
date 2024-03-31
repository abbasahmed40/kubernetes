#!/bin/bash

echo "Updating Yum...."
sudo yum -y update


echo "Installing Kubelet, Kubeadm and Kubectl......"
# update: switching to another repo for ref please visit 
# https://kubernetes.io/docs/tasks/administer-cluster/kubeadm/change-package-repository/
cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://pkgs.k8s.io/core:/stable:/v1.28/rpm/
enabled=1
gpgcheck=1
gpgkey=https://pkgs.k8s.io/core:/stable:/v1.28/rpm/repodata/repomd.xml.key
exclude=kubelet kubeadm kubectl cri-tools kubernetes-cni



sudo yum -y install epel-release vim git curl wget kubelet kubeadm kubectl --disableexcludes=kubernetes


echo "Your Kubeadm version is......"
sudo kubeadm version

echo "Checking the current status of selinux"
sudo sestatus

echo "Disabling SE Linux and Swap for You"
sudo setenforce 0
sudo sed -i 's/^SELINUX=.*/SELINUX=disabled/g' /etc/selinux/config

sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
sudo swapoff -a

echo "Restaring your system to accept selinux disabled"
sudo init 6
