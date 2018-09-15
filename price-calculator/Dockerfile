FROM ruby:2.5-alpine

RUN apk add --update build-base curl --no-cache

ENV APP_HOME /price-calculator
RUN mkdir $APP_HOME

WORKDIR $APP_HOME

COPY Gemfile* $APP_HOME/
RUN bundle install --without test

COPY . .

EXPOSE 3000
ENTRYPOINT ["bundle", "exec", "rackup", "config.ru", "-p", "3000", "-o", "0.0.0.0"]
