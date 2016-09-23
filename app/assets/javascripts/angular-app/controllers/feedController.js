angular.module('BitToriousApp').controller('FeedController', ['$scope', '$location', 'growl', 'Restangular', function($scope, $location, growl, Restangular) {

	console.log("Initializing AngularJS FeedController.");

	// Administrators
	// if($('#dashboard').attr('admin-controls') == 'true') {
		// console.log("Showing admin controls.");
		// TODO REFACTOR: This is needed for permission assignment. Change to a dynamic server-side search.
		Restangular.all('users').getList().then(function(users) {
			$scope.users = users;
		});
	// } else {
		// console.log('Not show admin controls.');

	// }

	var port = $location.port();
	var proto = $location.protocol();
	$scope.urlRoot = proto + "://" + $location.host();
	if((proto == 'http' && port == 80) || (proto == 'https' && port == 443)) {
		// We don't need to explicitly set the port.
	} else {
		$scope.urlRoot += ":" + port;
	}

	$scope.selectedFeed = null;
	Restangular.all('feeds').getList().then(function(feeds) {
		$scope.feeds = feeds;
		if($scope.feeds != null && $scope.feeds.length > 0) {
			$scope.selectFeed($scope.feeds[0]);
		}
	});

	$scope.selectFeed = function(f) {
		console.log("Selected feed: " + f.id);
		$scope.selectedFeed = f;
		// Fetch permissions.
		if($scope.selectedFeed.can_update) {
			f.getList('permissions').then(function(permissions) {
				console.log("Loaded " + permissions.length + " permissions.");
				$scope.selectedFeed.permissions = permissions;
			});
		}
		f.getList('torrents').then(function(torrents) {
			console.log("Loaded " + torrents.length + " torrents.");
			// angular.copy(torrents, $scope.selectedFeed.torrents);
			$scope.selectedFeed.torrents = torrents;
			if($scope.selectedFeed.torrents.length > 0) {
				$scope.selectTorrent($scope.selectedFeed.torrents[0]);
			} else {
				$scope.selectedTorrent = null;
			}
		});

	};

	$scope.templateUrl = function(name) {
		return "/feeds/" + name + '.html';
	}

	function newFeed() {
		$scope.newFeed = {'replication_percentage' : 20};
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
			$scope.selectFeed(feed);
			growl.success("Feed " + feed.name +" created.", {title : "Success!"});
		});
	}

	$scope.updateFeed = function() {
		$scope.selectedFeed.patch().then(function(f) {
			growl.success("Feed updated.", {title : "Success!"});
			console.log("Successfully updated feed.");
		});
	};

	$scope.deleteFeed = function(f) {
		// $scope.selectedFeed
		f.remove().then(function(feed) {
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

	$scope.selectTorrent = function(t) {
		$scope.selectedTorrent = t;
		if(t.active_peers == null) {
			t.getList('peers').then(function(actives) {
				t.active_peers = actives;
				refreshMap(actives);
			});;
		}
		// refreshMap(t.active_peers);
	};
	$scope.$watch("selectedTorrent", function() {
		if($scope.selectedTorrent != null && $scope.selectedTorrent.active_peers != null) {
			refreshMap($scope.selectedTorrent.active_peers);
		}
	});

	$scope.deleteTorrent = function(t) {
		// $scope.selectedTorrent
		t.remove().then(function() {
			console.log("Deleted torrent ID: " + $scope.selectedTorrent.id);
			// Remove from local array.
			var i = $scope.selectedFeed.torrents.indexOf(t);
			if(i > -1) {
				$scope.selectedFeed.torrents.splice(i, 1);
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
	};

	$scope.deletePermission = function(perm) {
		var f = $scope.selectedFeed;
		console.log("Revoking " + perm.role + " permission for " + perm.user.name + " on " + f.name);
		perm.remove().then(function() {
			growl.success("Role revoked.");
			var i = f.permissions.indexOf(perm);
			if(i > -1) {
				f.permissions.splice(i, 1);
			}
		});
	};

	$scope.createPermission = function(user, role) {
		var f = $scope.selectedFeed;
		console.log("Granting " + role + " permission for " + user.name + " on " + f.name);
		f.post('permissions', {'permission' : {'role' : role, 'user_id' : user.id}}).then(function(perm) {
			growl.success(user.name + " has been granted " + role + " permissions for " + f.name + '.');
			f.permissions.push(perm);
		}, function(e) {
			growl.error("Permission couldn't be granted. Are they already assigned a role?", {title: "Error :("});
			console.log("Server refused to create permission: " + e);
		});

	};

	$scope.userSearch = { 'text' : ''};
	$scope.userFilterMatch = function(user) {
		// console.log("FILTER: " + $scope.userSearch.text + user.name);
		return user.name.toLowerCase().indexOf($scope.userSearch.text.toLowerCase()) >= 0
	}

}]);
