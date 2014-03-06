$(function() {

	// Hide the torrent details section by default.
	$('#torrent_details').hide();

	// Feed selection:
	feed_handler = function(e) {
		e.preventDefault();

		// Close the currently selected torrent details area, if present.
		$('#torrent_details').slideUp();
		
		feed_id = $(this).data('id');
		console.log("Loading feed ID: " + feed_id);
		$('.success').removeClass('success');
		$(this).parent().addClass('success');
		$.ajax({
			url: $(this).data('href') + '.json',
			success: function(data) {
				$('#feed_details').replaceWith(data['torrent_html']);
				// $('#torrents table#feed_torrents tbody').replaceWith(data['torrent_html']);
				$('#torrents .btn.disabled').removeClass('disabled');
				$('form #torrent_feed_id').val(feed_id);
				$('#torrents td').effect('highlight');
				// $('html, body').animate({scrollTop: $("#torrents").offset().top - 100}, 2000);
			}
		});
		return false;
	};
	$('#feeds tr.feed_link td:nth-child(1), #feeds tr.feed_link td:nth-child(2)').on('click', feed_handler);


	// Torrent selection:
	torrent_handler = function(e) {
		e.preventDefault();
		$('#torrent_details').slideUp();
		$('#torrents .success').removeClass('success');
		$(this).parent().addClass('success');
		$.ajax({
			url: $(this).parent().data('href'),
			success: function(data){
				$('#torrent_details').html(data).slideDown(800, function(){
					$('html, body').animate({scrollTop: $("#torrent_details").offset().top - 100}, 2000);
				});
			}
		});
		return false;
	};

	$('#torrents').on('click',	'.torrent_link td:nth-child(1),' +
															'.torrent_link td:nth-child(2),' +
															'.torrent_link td:nth-child(3),' +
															'.torrent_link td:nth-child(4),' +
															'.torrent_link td:nth-child(5)',
														torrent_handler);


	// Show RSS link(s) dialog:
	$('.show_rss_dialog_button').on('click', function(e) {
		console.log('Showing feed RSS URL.');
		url = $(this).data('url');
		$('#rss_link').attr('href', url);
		$('#rss_link').html(url);
		// return false;
		// $('#create_feed_dialog form').submit();
	});

	// Create feed dialog:
	$('#create_feed_dialog .btn-primary').on('click', function(e) {
		console.log('Saving new feed.');
		$('#create_feed_btn').button('loading');
		$('#create_feed_dialog form').submit();
	});

	$('#upload_torrent_dialog #publish_btn').on('click', function(e) {
		$(this).button('loading');
	});

	// Torrent details map stuff.
	// map = document.getElementById("map_canvas");
	// if(map) {

	// }
	// new google.maps.Map(document.getElementById("map_canvas"),
	//           mapOptions);
	

});