#!/bin/bash

# eval $(ssh-agent)
# ssh-add
# buildx build . -t picker24/psyche_3_73:debian_bullseye-slim --ssh default --build-arg ND280ARCH=aarch64
# --platform=linux/amd64,linux/arm64

for i in buildbox root_v6_24_06; do # neut_oa2021 t2kreweight_oa2021; do 
	cd ${i};
	docker build . -t picker24/${i}:debian_bullseye-slim;
	cd ../;
done