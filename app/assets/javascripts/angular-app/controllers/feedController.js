angular.module('BitToriousApp').controller('FeedController', function($scope, Restangular) {

	console.log("Initializing AngularJS FeedController.");

	Restangular.all('feeds').getList().then(function(feeds) {
		$scope.feeds = feeds;
	});

	$scope.selectedFeed = null;
	if($scope.feeds != null && $scope.feeds.length > 0) {
		$scope.selectedFeed = $scope.feeds[0];
	}

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
			$scope.selectedFeed.torrents = torrents;
		});
		$scope.selelctedTorrent = null;
	};

	$scope.templateUrl = function(name) {
		return "/feeds/" + name + '.html';
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

	function newTorrent() {
		$scope.newTorrent = {'torrent' : {}};
	}

	$scope.setTorrentFile = function(e) {
		// var $scope = this.$scope;
    	// $scope.$apply(function() {
    		console.log("SETTING: " + e.files[0]);
        	$scope.newTorrent.torrent.file = e.files[0];
	    // });
	};

	$scope.newTorrentDialog = function() {
		newTorrent();
		$("#create_torrent_dialog").modal();
		$("#create_torrent_dialog input[name='name']").focus();
	}

	$scope.createTorrent = function() {
		console.log("Creating torrent: " + $scope.newTorrent);
		$scope.selectedFeed.post('torrents', $scope.newTorrent).then(function(torrent) {
			console.log("Created new torrent! ID: " + torrent.id);
			$scope.selectedFeed.torrents.push(torrent);
			newTorrent();
			$("#create_torrent_dialog").modal('hide');
		}, function(response) {
			var errors = response.data.errors;
			$scope.newTorrent.errors = errors;
			var msgs = [];
			Object.keys(errors).forEach(function(k) {
				msgs.push(errors[k]);
			});
			$scope.newTorrent.errorMessage = msgs.join(' ');
			console.log("Server refused to create torrent with status code: " + response);
		});
	}

	$scope.selectTorrent = function(slug) {
		console.log("Selected torrent: " + slug);
		for (var i = 0; i < $scope.selectedFeed.torrents.length; i++) {
			t = $scope.selectedFeed.torrents[i];
			if(t.slug == slug) {
				$scope.selectedTorrent = t;
				break;
			}
		};
		// Restangular.one('torrents', slug)
		$scope.selectedFeed.one('torrents', slug).get().then(function(torrent) {
			console.log("Loaded torrent : " + torrent.name);
			$scope.selectedTorrent = torrent;
		});
	};

});