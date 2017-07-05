FROM twiliodeved/api-snippets-base:ruby

RUN rm /bin/sh && ln -s /bin/bash /bin/sh

ENV RUN_ENV=test
ENV FAKE_CERT_PATH=/twilio-api-faker/keystore/twilio_fake.pem

RUN git clone https://github.com/TwilioDevEd/twilio-api-faker.git && \
    cp /twilio-api-faker/keystore/twilio_fake.pem /usr/local/share/ca-certificates/twilio_fake.crt

RUN cp $FAKE_CERT_PATH /usr/local/share/ca-certificates/twilio_fake.crt && \
    update-ca-certificates

RUN /bin/bash -l -c "gem install json colorize nokogiri"

RUN pip install virtualenvwrapper

RUN mkdir /.virtualenvs

ENV WORKON_HOME /.virtualenvs

RUN /bin/bash -l -c "source /usr/local/bin/virtualenvwrapper.sh"
