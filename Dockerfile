FROM ruby:2.4.1-alpine

ENV RAILS_ENV production
ENV RACK_ENV production
ENV SECRET_KEY_BASE 1

RUN mkdir /app

WORKDIR /tmp
COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock

RUN echo "@edge https://nl.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories \
 && BUILD_DEPS=" \
    postgresql-dev \
    libxml2-dev \
    libxslt-dev \
    build-base" \
 && apk -U upgrade && apk add \
    $BUILD_DEPS \
    nodejs@edge \
    nodejs-npm@edge \
    cyrus-sasl-dev \
    linux-headers \
    libpq \
    libxml2 \
    libxslt \
    libgsasl \
    file \
    git \
    imagemagick@edge \
    tzdata \
 && bundle install --jobs 20 --retry 5 --without test development \
 && npm install -g yarn \
 && update-ca-certificates \
 && apk del $BUILD_DEPS \
 && rm -rf /tmp/* /var/cache/apk/*

# RUN apt-get update && apt-get dist-upgrade -y && \
#   apt-get install -y libsasl2-dev nodejs

# RUN bundle install --jobs 20 --retry 5 --without development test


# ADD . /app
WORKDIR /app
COPY . ./

RUN bundle exec rake assets:precompile ON_DOCKER_BUILD=1
# RUN bundle exec rails assets:precompile ON_DOCKER_BUILD=1

EXPOSE 3000

ENV RAILS_SERVE_STATIC_FILES 1

# Run it
ENTRYPOINT ["bin/start.sh"]
# ENTRYPOINT ["bundle", "exec", "rails", "server", "-p", "3000", "-b", "0.0.0.0"]
