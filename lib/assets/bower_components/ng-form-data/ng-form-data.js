/*! ng-form-data - v 0.0.1 - Fri Mar 14 2014 14:05:10 GMT+0800 (CST)
 * https://github.com/tomchentw/ng-form-data
 * Copyright (c) 2014 [tomchentw](https://github.com/tomchentw);
 * Licensed [MIT](http://tomchentw.mit-license.org)
 */
/*global angular:false*/
(function(){
  var FileWithFormDataInterceptor, toString$ = {}.toString;
  FileWithFormDataInterceptor = 'FileWithFormDataInterceptor';
  angular.module('ng-form-data', []).directive('input', function(){
    function postLinkFn($scope, $element, $attrs, ctrl){
      var ngModelCtrl;
      ngModelCtrl = ctrl || {
        $setViewValue: angular.noop
      };
      ngModelCtrl.$open = function(){
        $element[0].click();
      };
      $element.on('change', function(){
        var files;
        files = this.files;
        $scope.$apply(function(){
          ngModelCtrl.$setViewValue($attrs.multiple
            ? files
            : files[0]);
        });
      });
    }
    return {
      restrict: 'E',
      require: '?ngModel',
      compile: function(tElement, tAttrs){
        if ('file' !== tAttrs.type) {
          return;
        }
        return postLinkFn;
      }
    };
  }).config(['$httpProvider'].concat(function($httpProvider){
    $httpProvider.interceptors.push(FileWithFormDataInterceptor);
  })).factory(FileWithFormDataInterceptor, ['$window'].concat(function($window){
    function encodeKey(keyPrefix, key){
      if (keyPrefix.length) {
        key = "[" + key + "]";
      }
      return keyPrefix + "" + key;
    }
    RequestTransformer.prototype._e = function(data, keyPrefix){
      var this$ = this;
      angular.forEach(data, function(value, key){
        key = encodeKey(keyPrefix, key);
        switch (toString$.call(value).slice(8, -1)) {
        case 'File':
        case 'Blob':
          this$._v = true;
          break;
        case 'Function':
          return;
        default:
          if (angular.isObject(value)) {
            return this$._e(value, key);
          }
        }
        this$._d.append(key, value);
      });
    };
    function RequestTransformer(config){
      this._d = new $window.FormData;
      this._v = false;
      this._e(config.data, '');
      if (this._v) {
        delete config.headers['Content-Type'];
        config.data = this._d;
        config.transformRequest = angular.identity;
      }
      return config;
    }
    return {
      request: function(it){
        if ('GET' === angular.uppercase(it.method)) {
          return it;
        }
        if ('FormData' === toString$.call(it).slice(8, -1)) {
          return it;
        }
        return new RequestTransformer(it);
      }
    };
  }));
}).call(this);
