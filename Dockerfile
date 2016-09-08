FROM ruby:2.3.1
MAINTAINER Preston Lee

RUN apt-get update && apt-get dist-upgrade -y && apt-get install -y build-essential

# Default shell as bash
RUN rm /bin/sh && ln -s /bin/bash /bin/sh


# Configure the main working directory. This is the base
# directory used in any further RUN, COPY, and ENTRYPOINT
# commands.
RUN mkdir -p /app
WORKDIR /app

# Copy the Gemfile as well as the Gemfile.lock and install
# the RubyGems. This is a separate step so the dependencies
# will be cached unless changes to one of those two files
# are made.
COPY Gemfile Gemfile.lock Rakefile config.ru ./
RUN gem install -N bundler && bundle install --jobs 16

# Copy the main application.
# COPY app app
# COPY bin bin
# COPY config config
# COPY db db
# COPY lib lib
# COPY log log
# COPY public public
# COPY test test
# COPY vendor vendor
COPY . .

# We'll run in production mode by default.
ENV RAILS_ENV=production

# Precompile all JS/CSS.
RUN bundle exec rake assets:precompile --trace

# Showtime!
EXPOSE 3000
CMD bundle exec rake db:migrate && bundle exec puma -C config/puma.rb
