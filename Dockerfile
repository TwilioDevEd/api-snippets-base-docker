FROM twiliodeved/api-snippets-base:ruby

RUN rm /bin/sh && ln -s /bin/bash /bin/sh

ENV RUN_ENV=test

RUN git clone https://github.com/TwilioDevEd/twilio-api-faker.git && \
    cp /twilio-api-faker/keystore/twilio_fake.pem /usr/local/share/ca-certificates/twilio_fake.crt && \
    update-ca-certificates

RUN pip install virtualenvwrapper

RUN mkdir /.virtualenvs

ENV WORKON_HOME /.virtualenvs

RUN /bin/bash -l -c "source /usr/local/bin/virtualenvwrapper.sh"
