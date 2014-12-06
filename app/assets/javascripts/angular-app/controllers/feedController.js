angular.module('BitToriousApp').controller('FeedController', function($scope, Restangular) {

	console.log("Initializing AngularJS FeedController.");

	Restangular.all('feeds').getList().then(function(feeds) {
		$scope.feeds = feeds;
	});

	$scope.selectedFeed = null;
	if($scope.feeds != null && $scope.feeds.length > 0) {
		$scope.selectedFeed = $scope.feeds[0];
	}
	$scope.torrents = null;
	$scope.selectFeed = function(slug) {
		console.log("Selected feed: " + slug);
		for (var i = 0; i < $scope.feeds.length; i++) {
			f = $scope.feeds[i];
			if(f.slug == slug) {
				$scope.selectedFeed = f;
				break;
			}
		};
		$scope.selectedFeed.getList('torrents').then(function(torrents) {
			console.log("Loaded " + torrents.length + " torrents.");
			$scope.torrents = torrents;
		});
	};

	$scope.templateUrl = function(name) {
		return "/feeds/" + $scope.selectedFeed.slug + '/' + name + '.html';
	}

	function newFeed() {
		$scope.newFeed = {'torrents' : []};
	}

	$scope.newFeedDialog = function() {
		newFeed();
		$("#create_feed_dialog").modal();
		$("#create_feed_dialog input[name='name']").focus();
	};

	$scope.createFeed = function() {
		$scope.feeds.post($scope.newFeed).then(function(feed) {
			console.log("Created new feed! ID: " + feed.id);
			$scope.feeds.push(feed);
			newFeed();
			$("#create_feed_dialog").modal('hide');
			$scope.selectedFeed = feed;
		});
	}

	$scope.deleteFeed = function() {
		$scope.selectedFeed.remove().then(function(feed) {
			console.log("Deleted feed ID: " + feed.id);
			// Remove from local array.
			for (var i = 0; i < $scope.feeds.length; i++) {
				if($scope.feeds[i].id == feed.id) {
					$scope.feeds.splice(i, 1);
				}
			}
			if($scope.selectedFeed.id == feed.id) {
				console.log("SELECETD: " + $scope.selectedFeed.id);
				$scope.selectedFeed == null;
				$scope.$apply;
			}
		});
	}

});