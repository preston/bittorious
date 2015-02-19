'use strict';

var app = angular.module('BitToriousVolunteer', [
  'ngCookies',
  'ngResource',
  'restangular',
  'ui.router',
  'angular-growl'
]);


app.config(function($stateProvider, $urlRouterProvider) {
  $urlRouterProvider.otherwise("settings");
  $stateProvider.state('visualize', {
    url: '/visualize',
    templateUrl: 'visualize.html'
  });
  $stateProvider.state('about', {
    url: '/about',
    templateUrl: 'about.html'
  });
  $stateProvider.state('settings', {
    url: '/settings',
    templateUrl: 'settings.html'
  });
});

app.config(['growlProvider', function(growlProvider) {
  growlProvider.globalTimeToLive(2000);
}]);

// Sidbar show/hide animation magic.
$(document).ready(function () {
  var trigger = $('.hamburger'),
      overlay = $('.overlay'),
     isClosed = true;

    trigger.click(function () {
      hamburger_cross();      
    });

    function hamburger_cross() {

      if (isClosed == true) {          
        // overlay.hide();
        trigger.removeClass('is-open');
        trigger.addClass('is-closed');
        isClosed = false;
      } else {   
        // overlay.show();
        trigger.removeClass('is-closed');
        trigger.addClass('is-open');
        isClosed = true;
      }
  }
  
  $('[data-toggle="offcanvas"]').click(function () {
        $('#wrapper').toggleClass('toggled');
  });  
});


