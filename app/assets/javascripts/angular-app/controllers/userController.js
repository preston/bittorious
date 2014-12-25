angular.module('BitToriousApp').controller('UserController', ['$scope', '$location', 'growl', 'Restangular', function($scope, $location, growl, Restangular) {

	console.log("Initializing AngularJS UserController.");

	// Administrators 
	Restangular.all('users').getList().then(function(users) {
		console.log("Loaded " + users.length + " users.");
		$scope.users = users;
		for (var i = 0; i < users.length; i++) {
			// var tmp = i; // We need to save a copy of 'i' for the closure so it isn't different in the callback.
			// console.log(tmp + " " + $scope.users[tmp].name);
			// $scope.users[i].getList('feeds').then(function(data) {
			// 	if(data.length > 0) {
			// 		console.log("FEEDS FOR USER " + data[0].user_id);
			// 		$scope.users[data[0].user_id].feeds = data;
			// 	}
			// });
			// $scope.users[i].getList('torrents').then(function(data) {
			// 	if(data.length > 0) {
			// 		console.log("TORRENTS FOR USER " + data[0].user_id);
			// 		$scope.users[data[0].user_id].torrents = data;
			// 	}
			// });
		}
		$scope.approved = $scope.users.filter(function(u) { u.approved });
		$scope.pending = $scope.users.filter(function(u) { !u.approved });
	});

	$scope.feedNames = function(u) {
		return _.pluck(u.feeds, 'name').join(', ')
	}
	$scope.torrentNames = function(u) {
		return _.pluck(u.torrents, 'name').join(', ')
	}

	$scope.update = function(user) {
		user.patch().then(function(u) {
			growl.success(u.name + ' has been updated!');
			// var i = $scope.users.indexOf(u);
			// if(i > -1) {
			// 	$scope.users.splice(i, 1);
			// }
		});
	}

	$scope.approve = function(user) {
		user.approved = true;
		user.post('approve').then(function(u) {
			growl.success(u.name + ' has been approved!');
			var i = $scope.users.indexOf(u);
			if(i > -1) {
				$scope.users.splice(i, 1);
			}
		});
	}

	$scope.delete = function(user) {
		user.remove().then(function(u) {
			growl.success(user.name + ' has been deleted from the system.');
			var i = $scope.users.indexOf(user);
			if(i > -1) {
				$scope.users.splice(i, 1);
			}
		});
	}

	$scope.deny = function(user) {
		user.post('deny').then(function(u) {
			growl.success(user.name + ' has been denied and removed from the system.');
			var i = $scope.users.indexOf(user);
			if(i > -1) {
				$scope.users.splice(i, 1);
			}
		});
	}

}]);
