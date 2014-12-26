var map;
var markers = [];

function initMap() {
	if(map == null) {
		console.log("Initializing map...");
		var mapOptions = {
			zoom: 4,
			center: new google.maps.LatLng(40.397, -98.644)
		};
		var tmp = document.getElementById("map_canvas");
		if(tmp != null) {
			map = new google.maps.Map(tmp, mapOptions);
		}
	} else {
		removeMarkers();
	}
}


function coordinatesToLatLong(latitude, longitude) {
	var ll = null;
	if(latitude == "" || longitude == ""){
		console.log("Peer coordinates are invalid. They will not be mapped.");
	} else {
		// console.log("Peer: " + latitude + ', ' + longitude);
		ll = new google.maps.LatLng(latitude, longitude);
	}
	return ll;
}

function addMarker(peer) {
	console.log('Adding marker...');
	var ll = coordinatesToLatLong(peer.latitude, peer.longitude);
	var marker = new google.maps.Marker({
		position: ll,
		map: map,
		title: peer.city_name + ', ' + peer.country_name,
		animation: google.maps.Animation.DROP
	});
	markers.push(marker);

	var contentString = "<dl><dt>Location</dt><dd>" + city + ', ' + country + "</dd><dt>Coordinates</dt><dd>" + latitude + ', ' + longitude + "</dd></dl>";
	var infowindow = new google.maps.InfoWindow({ content: contentString });
	google.maps.event.addListener(marker, 'click', function() {
		infowindow.open(map,marker);
	});
}

function removeMarkers() {
	console.log('Removing markers from map...');
	$.each(markers, function(i, m) {
		m.setMap(null);
	});
	markers = [];
	markers.length = 0;
}


function refreshMap(peers) {
	if(map == null) {
		initMap();
	}
	console.log('Refreshing map...');
	for(var i = 0; i < peers.length; i++)  {
		addMarker(peers[i]);
		// addMarker({'latitude' : '38.422', 'longitude' : '262.273', 'city' : 'Nowhere', 'country' : 'United States'});
	};
}

