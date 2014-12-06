app = angular.module('BitToriousApp', [
	'templates',
	'restangular',
	'ngRoute',
	'relativeDate'
]);

// For compatibility with Rails CSRF protection

app.config(
	['$httpProvider', 'RestangularProvider', function($httpProvider, RestangularProvider) {
		$httpProvider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content');
		RestangularProvider.setRequestSuffix('.json');
	}]);

app.run(function() {
	console.log('BitTorious App is up and running!');
});
