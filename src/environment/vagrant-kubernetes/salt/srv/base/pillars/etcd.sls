etcd:
  image: gcr.io/etcd-development/etcd:v3.3.11
  bind_address: 0.0.0.0
  pki_directory:
    host: /vagrant/salt/srv/base/assets/config/kubernetes/certificates
    guest: /etc/ssl/certs
