.PHONY: build_node

USERNAME=twiliodeved

build_node:
		docker build . -f Dockerfile-node -t $(USERNAME)/api-snippets-base:node --no-cache

build_python:
		docker build . -f Dockerfile-python -t $(USERNAME)/api-snippets-base:python --no-cache

build_mono:
		docker build . -f Dockerfile-mono -t $(USERNAME)/api-snippets-base:mono --no-cache

build_java:
		docker build . -f Dockerfile-java -t $(USERNAME)/api-snippets-base:java --no-cache

build_ruby:
		docker build . -f Dockerfile-ruby -t $(USERNAME)/api-snippets-base:ruby --no-cache

build_base:
		docker build . -t $(USERNAME)/api-snippets-base --no-cache

build:
		make build_node && make build_python  && make build_mono && \
		make build_java && make build_ruby && make build_base
