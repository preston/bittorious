var moduleName = 'WelcomeController';
var app = angular.module('BitToriousVolunteer');
app.controller(moduleName, function($scope, $http, growl, Restangular) {


	$scope.loadSettings = function() {
		$http.get('/settings.json').success(function(data, status, headers, config) {
			$scope.settings = data;
			growl.success('User settings loaded.');
			console.log(data);
			$scope.loadFeeds();
		})
		.error(function(data, status, headers, config) {
		 	// growl.error("Failed to load user settings.");
			console.log(status);
		});
	};


	$scope.saveSettings = function() {
		var settings = $scope.settings;
		console.log("Saving settings: " + settings);
		// $scope.reinitializePortalClient();
		$http.post('/settings', settings).success(function(data) {
			growl.success("Settings saved.");
		}).error(function(data) {
			growl.error("Settings couldn't be saved.");
		});
	};

	$scope.loadStatus = function() {
		$http.get('/status.json').success(function(data, status, headers, config) {
			$scope.status = data;
			$scope.status.disk_used_percent = (100.0 * $scope.status.disk_used_bytes / $scope.settings.disk_maximum_bytes)
			console.log("Updated status.");
			initMap();
		});
	};

	$scope.loadFeeds = function() {
		$http.get($scope.settings.url + '/feeds.json').success(function(feeds, status, headers, config) {
			console.log('Loaded ' + feeds.length + ' feeds.');
			$scope.feeds = feeds;
			if($scope.settings.feed.slug == null) {
				$scope.settings.feed = $scope.feeds[0];
				$scope.saveSettings();
				$scope.selectFeed($scope.settings.feed);				
			} else {
				$scope.selectFeed($scope.settings.feed);
			}
		});	
	};

	$scope.loadStatus = function() {
		$http.get('/status.json').success(function(data, status, headers, config) {
			$scope.status = data;
		});
	}



	$scope.selectFeed = function(f) {
		// console.log("Selected feed: " + f.slug);
		// $scope.settings.feed = f;
		// if($scope.settings.feed.slug == null) {
		// }
		$http.get($scope.settings.url + '/feeds/' + f.slug + '.json').success(function(feed, status, headers, config) {
			$scope.torrents = feed.torrents;
			console.log("Loaded " + $scope.torrents.length + " torrents.");
			if($scope.torrents.length > 0) {
				$scope.selectedTorrent = $scope.torrents[0];
				$scope.loadPeers();
			} else {
				$scope.selectedTorrent = null;
			}
		});
		
	};

	// $scope.$watch("selectedTorrent", function() {
	// 	// $scope.loadPeers();
	// });

	$scope.loadPeers = function() {
		// $scope.selectedTorrent = t;s
		var url = $scope.settings.url + '/feeds/' + $scope.settings.feed.slug + '/torrents/' + $scope.selectedTorrent.id + '.json';
		$http.get(url).success(function(torrent, status, headers, config) {
			$scope.peers = torrent.active_peers;
		});;	
	};

	$scope.loadSettings();
	console.log(moduleName + ' initialized.');

});