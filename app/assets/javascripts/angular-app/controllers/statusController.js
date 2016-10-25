// angular.module('BitToriousApp').controller('PeerController', ['$scope', 'growl', 'Restangular', function($scope, growl, Restangular) {
//
// 	console.log("Initializing PeerController.");
//
// 	Restangular.all('status').getList().then(function(data) {
// 		console.log('Loaded ' + data.length + ' peers.');
// 		$scope.peers = data;
// 		refreshMap(data);
// 	});
//
// }]);
