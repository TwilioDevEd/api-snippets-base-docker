FROM twiliodeved/api-snippets:base

ENV RUN_ENV=test
ENV NODE_TLS_REJECT_UNAUTHORIZED=0
ENV FAKE_CERT_PATH=/twilio-api-faker/keystore/twilio_fake.pem
ENV GRADLE_OPTS="-Dorg.gradle.daemon=true"

COPY . /src

WORKDIR /src

RUN /bin/bash -l -c "ruby ./tools/snippet-testing/model/dependency.rb"
