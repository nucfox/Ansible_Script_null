#!/bin/bash

PATH=/usr/local/sbin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin
source /etc/profile

cfssl gencert -initca ca-csr.json | cfssljson -bare ca

cfssl gencert -ca=ca.pem \
-ca-key=ca-key.pem \
-config=ca-config.json \
-profile=kubernetes etcd-csr.json | cfssljson -bare etcd

cfssl gencert -ca=ca.pem \
-ca-key=ca-key.pem \
-config=ca-config.json \
-profile=kubernetes admin-csr.json | cfssljson -bare admin

cfssl gencert -ca=ca.pem \
-ca-key=ca-key.pem \
-config=ca-config.json \
-profile=kubernetes flanneld-csr.json | cfssljson -bare flanneld

cfssl gencert -ca=ca.pem \
-ca-key=ca-key.pem \
-config=ca-config.json \
-profile=kubernetes kubernetes-csr.json | cfssljson -bare kubernetes

cfssl gencert -ca=ca.pem \
-ca-key=ca-key.pem \
-config=ca-config.json \
-profile=kubernetes kube-proxy-csr.json | cfssljson -bare kube-proxy

cfssl gencert -ca=ca.pem \
-ca-key=ca-key.pem \
-config=ca-config.json \
-profile=kubernetes harbor-csr.json | cfssljson -bare harbor

mkdir -p pem csr
mv *.pem pem
mv *.csr csr

cp -f pem/ca*pem pem/etcd*pem ../roles/etcd/files/pem/
cp -f pem/ca*pem pem/admin*pem ../roles/kubernetes_client/files/pem/
cp -f pem/ca*pem pem/flanneld*pem ../roles/flannel/files/pem/
cp -f pem/ca*pem pem/kubernetes*pem ../roles/kubernetes_server/files/pem/
cp -f pem/ca*pem pem/kube-proxy*pem ../roles/kubernetes_node/files/pem/
cp -f pem/ca*pem pem/harbor*pem ../roles/harbor/files/pem/
cp -f pem/ca.pem ../roles/distribution_harbor_key/files/pem/
