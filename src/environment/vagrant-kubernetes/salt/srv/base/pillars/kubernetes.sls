kubernetes:
  # The base staging directory to use for kubernetes files
  staging_directory: /vagrant/staging

  # The archive path to use for Kubernetes client binaries
  client_binaries_archive: https://dl.k8s.io/v1.13.0/kubernetes-client-linux-amd64.tar.gz
  # The hash of the Kubernetes client binaries archive
  client_binaries_archive_hash: 61a6cd3b1fb34507e0b762a45da09d88e34921985970a2ba594e0e5af737d94c966434b4e9f8e84fb73a0aeb5fa3e557344cd2eb902bf73c67d4b4bff33c6831
  # The list of client binaries to make global
  client_binaries_installed:
    - kubectl

  # The archive path to use for Kubernetes server binaries
  server_binaries_archive: https://dl.k8s.io/v1.13.0/kubernetes-server-linux-amd64.tar.gz
  # The hash of the Kubernetes server binaries archive
  server_binaries_archive_hash: a8e3d457e5bcc1c09eeb66111e8dd049d6ba048c3c0fa90a61814291afdcde93f1c6dbb07beef090d1d8a9958402ff843e9af23ae9f069c17c0a7c6ce4034686
  # The list of server binaries to make global
  server_binaries_installed:
    - apiextensions-apiserver
    - cloud-controller-manager
    - hyperkube
    - kube-apiserver
    - kube-controller-manager
    - kube-proxy
    - kube-scheduler
    - kubeadm
    - kubectl
    - kubelet
    - mounter

  # The archive path to use for Kubernetes node binaries
  node_binaries_archive: https://dl.k8s.io/v1.13.0/kubernetes-node-linux-amd64.tar.gz
  # The hash of the Kubernetes node binaries archive
  node_binaries_archive_hash: 9d18ba5f0c3b09edcf29397a496a1e908f4906087be3792989285630d7bcbaf6cd3bdd7b07dace439823885acc808637190f5eaa240b7b4580acf277b67bb553
  # The list of node binaries to make global
  node_binaries_installed:
    - kube-proxy
    - kubeadm
    - kubectl
    - kubelet

  # The template to use when configuring the nginx reverse proxy for the api server
  control_plane_rp_template: salt://config/kubernetes/nginx/control_plane_nginx_site.template
  # The port for the api server and control plane reverse proxy to listen on
  api_server_port: 6379

  api_server_ca:
  api_server_key:
  api_server_certificate:
