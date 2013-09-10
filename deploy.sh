#!/bin/bash

# Copyright (C) 2012 AMEE UK Ltd. - http://www.amee.com
# Released as Open Source Software under the BSD 3-Clause license. See LICENSE.txt for details.

if [ -z "$2" ]; then
  echo "Usage:  $0 <build_name> <env>"
  exit
fi

gemset=$1

env=$2

# Default options for gem commands
gem_opts='--no-rdoc --no-ri'

# Load RVM as a function so we can switch from within the script
# https://rvm.beginrescueend.com/workflow/scripting/
. "/usr/local/rvm/src/rvm/scripts/rvm"

# If there is an .rvmrc, grab the ruby version from it - default to 1.8.7
ruby='1.9.3'
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
  cap='bundle exec cap'
fi

# Install the CI reporter gem to get JUnit output
gem install capistrano 

  # Get the rake task from the command line and run it
$cap $env deploy