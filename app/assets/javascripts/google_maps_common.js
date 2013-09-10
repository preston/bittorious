var map;
var markers = [];
var peers = {};

function geoDataToLatLong(latitude,longitude) {
	var ll = null;
	if(latitude != "0" && longitude != "0"){
		console.log(latitude + ' ' + longitude);
		ll = new google.maps.LatLng(latitude, longitude);
	}
	return ll;
}

function addMarker(peer) {
  console.log('adding marker');
	var marker = new google.maps.Marker({
  	position: peer,
    map: map,
		animation: google.maps.Animation.DROP
  });
  markers.push(marker);
}

function removeMarkers() {
  console.log('removing markers');
  $.each(markers, function(i, m) {
    m.setMap(null);
  });
  markers = [];
  markers.length = 0;
}

function initMapData() {
  console.log('init map');
  removeMarkers();
	$.each($('.peer'), function(i, e) {
    console.log("Adding Marker.");
    var ll = geoDataToLatLong(e.getAttribute('data-latitude'), e.getAttribute('data-longitude'));
    addMarker(ll);
	});
}




// $(function() {

// 	// Bind UI controls:
// 	$('#peer_visibility_button').live('click', function() {
// 		console.log("Toggling map peer markers.");
// 		on = $(this).hasClass('active');
// 		if(on) {
// 			removeMarkers();			
// 		} else {
// 			addMarkers();
// 		}
// 	});
// });