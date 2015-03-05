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
	docker run -d -p 443:443 -p 9390:9390 -p 9391:9391 -v $(HOME)/openvas:/usr/local/var/lib/openvas --name testbase mikesplain/openvas:testbase
	until docker logs --tail 50 testbase 2>&1 | grep -E 'Data Base Updated'; do \
		echo "Waiting for script completion..." ; \
		sleep 30 ; \
	done
	echo "Done."
	echo "Waiting for startup to complete."
	until ps aux | grep -v grep | grep -E 'openvassd: Reloaded'; do \
		echo "." ; \
		sleep 2 ; \
	done
	echo "NVTs loading. Waiting to complete"
	while ps aux | grep -v grep | grep -v 'openvassd: Reloaded all the NVTs' | grep -E 'openvassd: Reloaded' ; do \
		echo "." ; \
		sleep 2 ; \
	done
	echo "NVTs done loading. Resting a moment"
	sleep 2
	echo "Rebuilding."
	while ps aux | grep -v grep | grep -E 'openvasmd: Rebuilding'; do \
		echo "." ; \
		sleep 2 ; \
	done
	echo "Testbase logs:"
	docker logs --tail 50 testbase 2>&1
	echo "Attempting login"
	docker-ssh testbase /openvas-check-setup >> ~/check_setup.log
	if grep -E 'It seems like your OpenVAS-7 installation is OK' ~/check_setup.log; \
	then \
		echo "Setup Successfully!" ; \
	else \
		echo "Setup failure" ; \
		exit 1 ; \
	fi

testfull:
	cp -R ~/openvas openvas_full/
	sed -i~ '3s/^/ADD openvas \/usr\/local\/var\/lib\/openvas/' openvas_full/Dockerfile
	sed -i -e '14,15d' openvas_full/Dockerfile
	sed -i~ '13s/ \&\& \\//' openvas_full/Dockerfile
	docker build -t mikesplain/openvas:full openvas_full
	git checkout openvas_full/Dockerfile
	sed -i -e 's/TAG/openvas:full/g' ./test/Dockerfile
	docker build -t mikesplain/openvas:testfull ./test
	docker run -d -p 443:443 -p 9390:9390 -p 9391:9391 -v $(HOME)/openvas:/usr/local/var/lib/openvas --name testfull mikesplain/openvas:testfull
	echo "Waiting for startup to complete."
	until ps aux | grep -v grep | grep -E 'openvassd: Reloaded'; do \
		echo "." ; \
		sleep 2 ; \
	done
	echo "NVTs loading. Waiting to complete"
	while ps aux | grep -v grep | grep -v 'openvassd: Reloaded all the NVTs' | grep -E 'openvassd: Reloaded'; do \
		echo "." ; \
		sleep 2 ; \
	done
	echo "NVTs done loading. Resting a moment"
	sleep 2
	echo "Rebuilding."
	while ps aux | grep -v grep | grep -E 'openvasmd: Rebuilding'; do \
		echo "." ; \
		sleep 2 ; \
	done
	docker-ssh testfull /openvas-check-setup >> ~/check_setup.log
	if grep -E 'It seems like your OpenVAS-7 installation is OK' ~/check_setup.log; \
	then \
		echo "Setup Successfully!" ; \
	else \
		echo "Setup failure" ; \
		exit 1 ; \
	fi

clean: cleanup

cleanup:
	sed -i -e 's/openvas_base/TAG/g' ./test/Dockerfile
	sed -i -e 's/openvas:full/TAG/g' ./test/Dockerfile
	rm -rf ./test/Dockerfile-e
	rm -rf openvas_full/Dockerfile~
	rm -rf openvas_full/openvas
