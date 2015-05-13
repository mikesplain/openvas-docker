SHELL := /bin/bash

default: containers

test: containers testcontainers


containers:
	docker build -t mikesplain/openvas_base openvas_base
	docker build -t mikesplain/openvas:full openvas_full

testcontainers:
	sed -i -e 's/TAG/openvas_base/g' ./test/Dockerfile
	docker build -t mikesplain/openvas:testbase ./test
	sed -i -e 's/openvas_base/openvas:full/g' ./test/Dockerfile
	docker build -t mikesplain/openvas:testfull ./test
	sed -i -e 's/full/TAG/g' ./test/Dockerfile

testbase:
	sed -i -e 's/TAG/openvas_base/g' ./test/Dockerfile
	docker build -t mikesplain/openvas:testbase ./test
	sed -i -e 's/openvas_base/TAG/g' ./test/Dockerfile

testfull:
	docker build -t mikesplain/openvas:full openvas_full
	git checkout openvas_full/Dockerfile
	sed -i -e 's/TAG/openvas:full/g' ./test/Dockerfile
	docker build -t mikesplain/openvas:testfull ./test

clean: cleanup

cleanup:
	sed -i -e 's/openvas_base/TAG/g' ./test/Dockerfile
	sed -i -e 's/openvas:full/TAG/g' ./test/Dockerfile
	rm -rf ./test/Dockerfile-e
	rm -rf openvas_full/Dockerfile~
	rm -rf openvas_full/openvas
