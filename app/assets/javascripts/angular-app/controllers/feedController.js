angular.module('BitToriousApp').controller('FeedController', ['$scope', '$location', 'growl', 'Restangular', function($scope, $location, growl, Restangular) {

	console.log("Initializing AngularJS FeedController.");

	var port = $location.port();
	var proto = $location.protocol();
	$scope.urlRoot = proto + "://" + $location.host();
	if((proto == 'http' && port == 80) || (proto == 'https' && port == 443)) {
		// We don't need to explicitly set the port.
	} else {
		$scope.urlRoot += ":" + port;
	}

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
		$scope.selectedTorrent = null;
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
			growl.success("Feed " + feed.name +"created.", {title : "Success!"});
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
			$scope.selectedFeed = null;
			growl.success("Feed deleted.", {title : "Success!"});
		}, function(e) {
			console.log("Server refused to delete feed: " + e);
		});
	}

	function newTorrent() {
		$scope.newTorrent = {'torrent' : {}};
	}

	$scope.setTorrentFile = function(e) {
       	$scope.newTorrent.torrent.file = e.files[0];
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
			growl.success("Torrent created.", {title : "Success!"});
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
		console.log("Loading torrent: " + slug);
		$scope.selectedFeed.one('torrents', slug).get().then(function(torrent) {
			// console.log("Loaded torrent : " + torrent.name);
			for (var i = 0; i < $scope.selectedFeed.torrents.length; i++) {
				if($scope.selectedFeed.torrents[i].slug == slug) {
					// $scope.selectedFeed.torrents[i] = torrent;
					break;
				}
			}
			$scope.selectedTorrent = torrent;
		});
	};

	$scope.deleteTorrent = function() {
		$scope.selectedTorrent.remove().then(function() {
			console.log("Deleted torrent ID: " + $scope.selectedTorrent.id);
			// Remove from local array.
			for (var i = 0; i < $scope.selectedFeed.torrents.length; i++) {
				if($scope.selectedFeed.torrents[i].id == $scope.selectedTorrent.id) {
					$scope.selectedFeed.torrents.splice(i, 1);
				}
			}
			$scope.selectedTorrent = null;
			growl.success("Torrent deleted.", {title : "Success!"});
		}, function(e) {
			growl.error("Torrent couldn't be deleted. Please refresh the page and try again.", {title: "Error :("});
			console.log("Server refused to delete torrent: " + e);
		});
	}

	$scope.updateTorrent = function() {
		$scope.selectedTorrent.patch().then(function(t) {
			growl.success("Torrent updated.", {title : "Success!"});
			console.log("Successfully updated torrent.");
		});
	}

}]);