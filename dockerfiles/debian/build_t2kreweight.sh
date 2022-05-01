#!/bin/bash

for i in buildbox root_v6_24_06; do # neut_oa2021 t2kreweight_oa2021; do 
	cd ${i};
	docker build . -t picker24/${i}:debian_bullseye-slim;
	cd ../;
done