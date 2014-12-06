angular.module('BitToriousApp').controller('FeedController', function($scope, Restangular) {

	console.log("Initializing AngularJS FeedController.");

	Restangular.all('feeds').getList().then(function(feeds) {
		$scope.feeds = feeds;
	});

});