.PHONY: kubernetes test

test:
	./run.sh

kubernetes:
	cd kubernetes && git checkout v1.13.5
	make WHAT='cmd/kubectl' -C kubernetes

