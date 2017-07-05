FROM joliveros/api-snippets-base

ENV RUN_ENV=test

COPY . /src

WORKDIR /src

RUN /bin/bash -l -c "ruby ./tools/snippet-testing/model/dependency.rb"
