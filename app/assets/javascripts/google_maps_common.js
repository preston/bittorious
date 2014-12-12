var mapInitialized = false;
var map;
var markers = [];
var peers = {};

function coordinatesToLatLong(latitude, longitude) {
	var ll = null;
	if(latitude == "" || longitude == ""){
    console.log("Peer coordinates are invalid. They will not be mapped.");
	} else {
    console.log("Peer: " + latitude + ', ' + longitude);
    ll = new google.maps.LatLng(latitude, longitude);
  }
	return ll;
}

function addMarker(latitude, longitude, city, country) {
  console.log('Adding marker...');
  var ll = coordinatesToLatLong(latitude, longitude);
	var marker = new google.maps.Marker({
  	position: ll,
    map: map,
    title: city + ', ' + country,
		animation: google.maps.Animation.DROP
  });
  markers.push(marker);
}

function removeMarkers() {
  console.log('Removing markers...');
  $.each(markers, function(i, m) {
    m.setMap(null);
  });
  markers = [];
  markers.length = 0;
}


function refreshMap(peers) {
  console.log('Refreshing map...');
  for(var i = 0; i < peers.length; i++)  {
    var p = peers[i];
    var latitude = p.latitude;
    var longitude = p.longitude;
    // addMarker('33.422', '112.273', 'Nowhere', 'United States');
    addMarker(latitude, longitude, p.city_name, p.country_name);
	};
}

