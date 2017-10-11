.PHONY: build_node

USERNAME=twiliodeved

build_node:
		docker build . -f Dockerfile-node -t $(USERNAME)/api-snippets-base:node --no-cache --squash

build_python:
		docker build . -f Dockerfile-python -t $(USERNAME)/api-snippets-base:python --no-cache --squash

build_mono:
		docker build . -f Dockerfile-mono -t $(USERNAME)/api-snippets-base:mono --no-cache --squash

build_java:
		docker build . -f Dockerfile-java -t $(USERNAME)/api-snippets-base:java --no-cache --squash

build_ruby:
		docker build . -f Dockerfile-ruby -t $(USERNAME)/api-snippets-base:ruby --no-cache --squash

build_base:
		docker build . -t $(REPO):$(COMMIT) --no-cache --squash


build:
		@echo "### build node image ###"
		@make build_node
		@echo "### build python image ###"
		@make build_python
		@echo "### build mono image ###"
		@make build_mono
		@echo "### build java image ###"
		@make build_java
		@echo "### build ruby image ###"
		@make build_ruby
		@echo "### build base image ###"
		@make build_base

FAKE_CERT = /usr/local/share/ca-certificates/twilio_fake.crt

define append_certs
	find /.virtualenvs/ -name '*cacert.pem' | while read line; do \
		cat $(FAKE_CERT) >> $$line; \
	done
endef

define save_dependencies
	cp -r /src/tools/dependencies /dependencies
	find /dependencies -name .eslintrc | xargs rm
endef

define python_deps
	pip install yapf flake8
endef

define ruby_deps
	rvm gemset create api-snippets && rvm use ruby-2.4.1@api-snippets --default
	gem install bundler json colorize nokogiri rubocop
endef

build_api_faker:
	cd /twilio-api-faker && gradle jar && cd /api-snippets-base

install_dependencies:
	$(call python_deps)
	$(call ruby_deps)
	cd /src && ruby tools/snippet-testing/model/dependency.rb && cd /api-snippets-base
	$(call append_certs)
	$(call save_dependencies)

define enabled_docker_experimental_features
	cp ./daemon.json /etc/docker/daemon.json
endef

install:
	@curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - \
	&& sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu trusty stable" \
	&& sudo apt-get update \
	&& apt-cache policy docker-ce \
	&& sudo apt-get install -y docker-ce \
	&& $(call enabled_docker_experimental_features) \
	&& sudo service docker restart \
	&& sleep 10
