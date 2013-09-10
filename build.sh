#!/bin/bash

# Copyright (C) 2012 AMEE UK Ltd. - http://www.amee.com
# Released as Open Source Software under the BSD 3-Clause license. See LICENSE.txt for details.

if [ -z "$2" ]; then
  echo "Usage:  $0 <build_name> <task>"
  exit
fi

gemset=$1

task=$2

# Default options for gem commands
gem_opts='--no-rdoc --no-ri'

# Load RVM as a function so we can switch from within the script
# https://rvm.beginrescueend.com/workflow/scripting/
. "/usr/local/rvm/src/rvm/scripts/rvm"

# If there is an .rvmrc, grab the ruby version from it - default to 1.8.7
ruby='2.0.0'
if [ -e '.rvmrc' ]; then
  # Get ruby version from .rvmrc
  ruby=`cat .rvmrc | sed "s:.* \(.*\)@.*:\1:"`
fi

# Get gemset name NOT from .rvmrc but from build name
# This is to avoid conflicts with different builds of same
# codebase
# Set up correct ruby
if ! (rvm list | grep $ruby); then
      rvm install $ruby
fi

# Use correct ruby
rvm use $ruby@$gemset --create

# If we're using bundler (i.e. there is a Gemfile)
rake='rake'
if [ -e 'Gemfile' ]; then
  # Make sure bundler is installed
  gem install bundler $gem_opts
  # Then run bundle to install dependencies
  bundle install --deployment
  # Run rake through bundler
  rake='bundle exec rake'
fi

if [[ -z "$3" ]]; then
  $rake $task
else
  # Install the CI reporter gem to get JUnit output
  gem install ci_reporter $gem_opts
  stub=`gem contents ci_reporter | grep stub.rake`

  # Get the rake task from the command line and run it
  $rake -f $stub ci:setup:rspec $task
fi