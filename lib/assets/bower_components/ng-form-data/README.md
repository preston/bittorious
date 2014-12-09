# ng-form-data
> Distributed via

[![Version     ](https://img.shields.io/gem/v/ng-form-data.svg)                               ](https://rubygems.org/gems/ng-form-data)
[![Bower version](https://badge.fury.io/bo/ng-form-data.png)](https://badge.fury.io/bo/ng-form-data)

> Boilerplate for AngularJS module by Tom Chen

[![Travis CI   ](https://img.shields.io/travis/tomchentw/ng-form-data/master.svg)             ](https://travis-ci.org/tomchentw/ng-form-data)
[![Quality     ](https://img.shields.io/codeclimate/github/tomchentw/ng-form-data.svg)        ](https://codeclimate.com/github/tomchentw/ng-form-data)
[![Coverage    ](https://img.shields.io/coveralls/tomchentw/ng-form-data.svg)                 ](https://coveralls.io/r/tomchentw/ng-form-data)
[![Dependencies](https://img.shields.io/gemnasium/tomchentw/ng-form-data.svg)                 ](https://gemnasium.com/tomchentw/ng-form-data)


## Project philosophy

### Develop in LiveScript
[LiveScript](http://livescript.net/) is a compile-to-js language, which provides us more robust way to write JavaScript.  
It also has great readibility and lots of syntax sugar just like you're writting python/ruby.


## Installation

### Just use it

* Download and include [`ng-form-data.js`](https://github.com/tomchentw/ng-form-data/blob/master/ng-form-data.js) OR [`ng-form-data.min.js`](https://github.com/tomchentw/ng-form-data/blob/master/ng-form-data.min.js).  

Then include them through script tag in your HTML.

### **Rails** projects (Only support 3.1+)

Add this line to your application's Gemfile:
```ruby
gem 'ng-form-data'
```

And then execute:

    $ bundle

Then add these lines to the top of your `app/assets/javascripts/application.js` file:

```javascript
//= require angular
//= require ng-form-data
```

And include in your `angular` module definition:
    
    /* 'tomchentw.boilerplate' module.
     */    
    var module = angular.module('my-awesome-project', ['tomchentw.boilerplate']).


## Usage


## Contributing

[![devDependency Status](https://david-dm.org/tomchentw/ng-form-data/dev-status.svg?theme=shields.io)](https://david-dm.org/tomchentw/ng-form-data#info=devDependencies)

1. Fork it ( https://github.com/tomchentw/ng-form-data/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request