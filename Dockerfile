FROM ruby:3.1.0

RUN mkdir /recipe_api
WORKDIR /recipe_api
COPY Gemfile /recipe_api/Gemfile
COPY Gemfile.lock /recipe_api/Gemfile.lock
RUN bundle install
COPY . /recipe_api

RUN chmod +x /recipe_api/entrypoint.sh
