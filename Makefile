.PHONY: build_node

USERNAME=twiliodeved
REPO=twiliodeved/api-snippets-base

define get_image_tag
	if [ -z "$$COMMIT" ]; then \
		IMAGE_TAG="latest"; \
	else \
		IMAGE_TAG=$$COMMIT; \
	fi
endef


build_node:
		docker build . -f Dockerfile-node -t $(USERNAME)/api-snippets-base:node --no-cache --squash

build_python:
		docker build . -f Dockerfile-python -t $(USERNAME)/api-snippets-base:python --no-cache --squash

build_mono:
		docker build . -f Dockerfile-mono -t $(USERNAME)/api-snippets-base:mono --no-cache --squash

build_dotnet:
		docker build . -f Dockerfile-dotnet -t $(USERNAME)/api-snippets-base:dotnet --no-cache --squash

build_java:
		docker build . -f Dockerfile-java -t $(USERNAME)/api-snippets-base:java --no-cache --squash

build_ruby:
		docker build . -f Dockerfile-ruby -t $(USERNAME)/api-snippets-base:ruby --no-cache --squash

build_base:
		$(call get_image_tag); \
		docker build . -t $(REPO):$$IMAGE_TAG --no-cache --squash

build:
		@echo "### build node image ###"
		@make build_node
		@echo "### build python image ###"
		@make build_python
		@echo "### build mono image ###"
		@make build_mono
		@echo "### build dotnet image ###"
		@make build_dotnet
		@echo "### build java image ###"
		@make build_java
		@echo "### build ruby image ###"
		@make build_ruby
		@echo "### build base image ###"
		@make build_base



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

install_dependencies:
	$(call python_deps)
	$(call ruby_deps)
	cd /src && ruby tools/snippet-testing/model/dependency.rb && cd /api-snippets-base
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
