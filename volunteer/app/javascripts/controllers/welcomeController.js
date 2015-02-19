var moduleName = 'WelcomeController';
var app = angular.module('BitToriousVolunteer');
app.controller(moduleName, function($scope, $http, growl, Restangular) {


	$scope.loadSettings = function() {
		$http.get('/settings.json').success(function(data, status, headers, config) {
			$scope.settings = data;
			growl.success('User settings loaded.');
			console.log(data);
			// $scope.reinitializePortalClient();

			$scope.loadFeeds();
		})
		.error(function(data, status, headers, config) {
		// 	// growl.error("Failed to load user settings.");
			console.log(status);
		});
	};

	// $scope.reinitializePortalClient = function() {
	// 	var url = $scope.settings.url;
	// 	console.log('Set new portal client URL: ' + url);
	// 	Restangular.setBaseUrl(url);
	// };


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

	$scope.refreshStatus = function() {
		$http.get('/status.json').success(function(data, status, headers, config) {
			$scope.status = data;
			$scope.status.disk_used_percent = (100.0 * $scope.status.disk_used_bytes / $scope.settings.disk_maximum_bytes)
			console.log("Updated status.");
		});
	};

	$scope.loadFeeds = function() {
		Restangular.allUrl('feeds', $scope.settings.url).getList().then(function(feeds) {
			console.log('Loaded ' + feeds.length + ' feeds.');
			$scope.feeds = feeds;
			if($scope.feeds != null && $scope.feeds.length > 0) {
				$scope.selectFeed($scope.feeds[0]);
			}
		});	
	};



	$scope.selectFeed = function(f) {
		console.log("Selected feed: " + f.slug);
		$scope.selectedFeed = f;
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


	$scope.selectTorrent = function(t) {
		$scope.selectedTorrent = t;
		if(t.active_peers == null) {
			t.getList('peers').then(function(actives) {
				t.active_peers = actives;
			});;	
		}
	};

	$scope.loadSettings();
	console.log(moduleName + ' initialized.');

});