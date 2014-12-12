var map;
var markers = [];
var peers = {};

function coordinatesToLatLong(latitude,longitude) {
	var ll = null;
	if(latitude != "" && longitude != ""){
		console.log(latitude + ' ' + longitude);
		ll = new google.maps.LatLng(latitude, longitude);
	}
	return ll;
}

function addMarker(peer) {
  console.log('Adding marker...');
	var marker = new google.maps.Marker({
  	position: peer,
    map: map,
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

var mapInitialized = false;

function refreshMap() {
  if(mapInitialized) {
    removeMarkers();
  }
  console.log('Refreshing map...');
	$.each($('.peer'), function(i, e) {
    var latitude = $(this).find('#latitude').val();
    var longitude = $(this).find('#longitude').val();
    // console.log("Adding Marker.");
    var ll = coordinatesToLatLong(latitude, longitude);
    addMarker(ll);
	});
}

