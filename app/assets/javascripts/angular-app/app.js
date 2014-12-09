app = angular.module('BitToriousApp', [
	'templates',
	'restangular',
	'ngRoute',
	'relativeDate',
	'ng-form-data',
	'humanizeFilters'
]);

// For compatibility with Rails CSRF protection

app.config(
	['$httpProvider', 'RestangularProvider', function($httpProvider, RestangularProvider) {
		$httpProvider.defaults.headers.common['X-CSRF-Token'] = $('meta[name=csrf-token]').attr('content');
		RestangularProvider.setRequestSuffix('.json');
		RestangularProvider.setRestangularFields({
			id: "slug"
		});
	}]);

app.run(function() {
	console.log('BitTorious App is up and running!');
});
