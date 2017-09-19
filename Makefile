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
		docker build . -t $(USERNAME)/api-snippets-base --no-cache --squash

build:
		make build_node && make build_python  && make build_mono && \
		make build_java && make build_ruby && make build_base

FAKE_CERT = /usr/local/share/ca-certificates/twilio_fake.crt

define append_certs
	find /.virtualenvs/ -name '*cacert.pem' | while read line; do \
		cat $(FAKE_CERT) >> $$line; \
	done
endef

define save_dependencies
	cp -r /src/tools/dependencies /dependencies
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
	$(call append_certs)
	$(call save_dependencies)
