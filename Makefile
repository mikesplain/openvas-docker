SHELL:=/bin/bash

DOCKER_REPOSITORY ?= quay.io
IMAGE ?= mikesplain/openvas

CONTAINER ?= openvas-full

ifndef TAG
  ifndef CI
    TAG=
  else
    TAG := -travis-${TRAVIS_BUILD_ID}
  endif
endif

.PHONY: default
default: help

.PHONY: clean
clean:
	rm -rf .data

.PHONY: build
build: build-full build-base # Builds all images

.PHONY: build-full
build-full: # Builds full Image
	docker build -t openvas:full full

.PHONY: build-base
build-base: # Builds base Image
	docker build -t openvas:base base

.PHONY: tag
tag: tag-full tag-base # Tags all images

.PHONY: tag-full
tag-full: # Tags full Image
	docker tag openvas:full ${DOCKER_REPOSITORY}/${IMAGE}:full${TAG}

.PHONY: tag-base
tag-base: # Tags base Image
	docker tag openvas:base ${DOCKER_REPOSITORY}/${IMAGE}:base${TAG}

.PHONY: push
push: push-full push-base # Pushes all images

.PHONY: push-full
push-full: # Pushes full Image
	docker push ${DOCKER_REPOSITORY}/${IMAGE}:full${TAG}

.PHONY: push-base
push-base: # Pushes base Image
	docker push ${DOCKER_REPOSITORY}/${IMAGE}:base${TAG}

.PHONY: docker-login
docker-login:
	@docker login -u="${QUAY_USER}" -p="${QUAY_PASSWORD}" ${DOCKER_REPOSITORY}

.PHONY: base
base: # Builds, tags and pushes the base image
	@$(MAKE) build-base
	@[ "${CI}" != "" ] && $(MAKE) docker-login && $(MAKE) tag-base && $(MAKE) push-base || echo

.PHONY: full
full: # Builds, tags and pushes the full image
	@$(MAKE) build-full
	@[ "${CI}" != "" ]&& $(MAKE) docker-login && $(MAKE) tag-full && $(MAKE) push-full || echo

.PHONY: test-base
test-base: # Tests the base build
	@echo "Starting testing container"
	@COMPOSEIMAGE="${DOCKER_REPOSITORY}/${IMAGE}:base${TAG}" docker-compose -f docker-compose.yml -f base/docker-compose.test.yml pull
	@COMPOSEIMAGE="${DOCKER_REPOSITORY}/${IMAGE}:base${TAG}" docker-compose -f docker-compose.yml -f base/docker-compose.test.yml up -d
	@CONTAINER=openvasdocker_openvas_1 $(MAKE) test-live
	@CONTAINER=openvasdocker_openvas_1 $(MAKE) test-curl

.PHONY: test-full
test-full: # Tests the full build
	@echo "Starting testing container"
	@docker run -d -p 443:443 --name openvas-full ${DOCKER_REPOSITORY}/${IMAGE}:full${TAG}
	@CONTAINER=openvas-full $(MAKE) test-live
	@CONTAINER=openvas-full $(MAKE) test-curl

.PHONY: test-live
test-live: # Confirms if testing container is live
	@echo "Waiting for startup to complete..."
	@until docker logs ${CONTAINER} | grep -E 'It seems like your OpenVAS-9 installation is'; do \
		echo . ;\
		sleep 5 ;\
	done

.PHONY: test-curl
test-curl: # Performs curl test against a live openvas container
	@echo Performing Test; \
	echo
	@response='$(shell curl -k https://localhost:443/login/login.html 2> /dev/null| grep -q "Greenbone Security Assistant"; echo "$$?")'; \
	[ $$response == "0" ] && echo "Greenbone started successfully!" || (echo "Greenbone couldn't be found. There's probably something wrong" && exit 1)

.PHONY: help
help: # Show this help
	@{ \
	echo 'Targets:'; \
	echo ''; \
	grep '^[a-z/.-]*: .*# .*' Makefile \
	| sort \
	| sed 's/: \(.*\) # \(.*\)/ - \2 (deps: \1)/' `: fmt targets w/ deps` \
	| sed 's/:.*#/ -/'                            `: fmt targets w/o deps` \
	| sed 's/^/    /'                             `: indent`; \
	echo ''; \
	echo 'CLI options:'; \
	echo ''; \
	grep '^[^\s]*?=' Makefile \
	| sed 's/\?=\(.*\)/ (default: "\1")/' `: fmt default values`\
	| sed 's/^/    /'; \
	echo ''; \
	echo 'Undocumented targets:'; \
	echo ''; \
	grep '^[a-z/.-]*:\( [^#=]*\)*$$' Makefile \
	| sort \
	| sed 's/: \(.*\)/ (deps: \1)/' `: fmt targets w/ deps` \
	| sed 's/:$$//'                 `: fmt targets w/o deps` \
	| sed 's/^/    /'               `: indent`; \
	echo ''; \
	} 1>&2; \
