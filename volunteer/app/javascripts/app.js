'use strict';

var app = angular.module('BitToriousVolunteer', [
  'ngCookies',
  'ngResource',
  'restangular',
  'ui.router'
]);

app.config(function($stateProvider, $urlRouterProvider) {

	console.log('Setting up UI state machine...');
	$urlRouterProvider.otherwise('/status');

	// $stateProvider.state('status', {
	// 	url: '/status',
	// 	templateUrl: 'partials/status'
	// });

	// $stateProvider.state('settings', {
	// 	url: '/settings',
	// 	templateUrl: 'partials/settings'
	// });

});

$(document).ready(function () {
  var trigger = $('.hamburger'),
      overlay = $('.overlay'),
     isClosed = false;

    trigger.click(function () {
      hamburger_cross();      
    });

    function hamburger_cross() {

      if (isClosed == true) {          
        overlay.hide();
        trigger.removeClass('is-open');
        trigger.addClass('is-closed');
        isClosed = false;
      } else {   
        overlay.show();
        trigger.removeClass('is-closed');
        trigger.addClass('is-open');
        isClosed = true;
      }
  }
  
  $('[data-toggle="offcanvas"]').click(function () {
        $('#wrapper').toggleClass('toggled');
  });  
});