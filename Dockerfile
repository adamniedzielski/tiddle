FROM ruby:3.1-alpine

RUN apk add build-base sqlite-dev tzdata git bash
RUN gem update --system && gem install bundler

WORKDIR /library

ENV BUNDLE_PATH=/vendor/bundle \
    BUNDLE_BIN=/vendor/bundle/bin \
    GEM_HOME=/vendor/bundle

ENV PATH="${BUNDLE_BIN}:${PATH}"
