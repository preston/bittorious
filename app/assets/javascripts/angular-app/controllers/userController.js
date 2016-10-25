// angular.module('BitToriousApp').controller('UserController', ['$scope', '$location', 'growl', 'Restangular', function($scope, $location, growl, Restangular) {
//
// 	console.log("Initializing AngularJS UserController.");
//
// 	// Administrators
// 	Restangular.all('users').getList().then(function(users) {
// 		console.log("Loaded " + users.length + " users.");
// 		$scope.users = users;
// 		$scope.approved = $scope.users.filter(function(u) { u.approved });
// 		$scope.pending = $scope.users.filter(function(u) { !u.approved });
// 	});
//
//
// 	$scope.feedNames = function(u) {
// 		return _.pluck(u.feeds, 'name').join(', ')
// 	}
// 	$scope.torrentNames = function(u) {
// 		return _.pluck(u.torrents, 'name').join(', ')
// 	}
//
// 	$scope.update = function(user) {
// 		user.patch().then(function(u) {
// 			growl.success(u.name + ' has been updated!');
// 		});
// 	}
//
// 	$scope.approve = function(user) {
// 		user.approved = true;
// 		user.post('approve', { 'id' : user.id }).then(function(u) {
// 			growl.success(u.name + ' has been approved!');
// 			var i = $scope.users.indexOf(u);
// 			if(i > -1) {
// 				$scope.users.splice(i, 1);
// 			}
// 		}, function(e) {
// 			console.log(e);
// 		});
// 	}
//
// 	$scope.delete = function(user) {
// 		user.remove().then(function(u) {
// 			growl.success(user.name + ' has been deleted from the system.');
// 			var i = $scope.users.indexOf(user);
// 			if(i > -1) {
// 				$scope.users.splice(i, 1);
// 			}
// 		});
// 	}
//
// 	$scope.deny = function(user) {
// 		user.post('deny', { 'id' : user.id }).then(function(u) {
// 			growl.success(user.name + ' has been denied and removed from the system.');
// 			var i = $scope.users.indexOf(user);
// 			if(i > -1) {
// 				$scope.users.splice(i, 1);
// 			}
// 		}, function(e) {
// 			console.log(e);
// 		});
// 	}
//
// }]);
