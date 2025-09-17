ARG MORPHEUS_IMAGE=whothefluff/morpheus-alatius-xml:v1.0.0

FROM ${MORPHEUS_IMAGE}

ARG DEBIAN_FRONTEND=noninteractive
ENV LANG=C.UTF-8

RUN apt-get update -qq && apt-get install -qq -y ruby ruby-dev libxml2 libxml2-dev libxslt1-dev

ADD . /app
WORKDIR /app

ENV RACK_ENV=production
ENV BUNDLE_SILENCE_ROOT_WARNING=1

RUN gem install bundler
RUN bundle install

CMD ["bundle", "exec", "ruby", "app.rb"]
