$(function() {

	// Hide the torrent details section by default.
	$('#torrent_details').hide();

	$('.dashboard').on('click',
							'tr.feed_link td:nth-child(1),' +
							'tr.feed_link td:nth-child(2)',
							feed_handler);

	$('.dashboard').on('click',	'.torrent_link td:nth-child(1),' +
								'.torrent_link td:nth-child(2),' +
								'.torrent_link td:nth-child(3),' +
								'.torrent_link td:nth-child(4),' +
								'.torrent_link td:nth-child(5)',
								torrent_handler);


	$('#upload_torrent_dialog #publish_btn').on('click', function(e) {
		$(this).button('loading');
	});


});



// Feed selection:
function feed_handler(e) {
	// e.preventDefault();

	torrent_details_hide();
	
	feed_id = $(this).data('id');
	console.log("Loading feed ID: " + feed_id);
	$('.success').removeClass('success');
	$(this).parent().addClass('success');
	$.ajax({
		url: $(this).data('href') + '.html',
		success: function(data) {


			$('#feed_details').html(data);
			// $('#feed_details').html(data['torrent_html']);
			// $('#torrents table#feed_torrents tbody').replaceWith(data['torrent_html']);
			// $('#torrents .btn.disabled').removeClass('disabled');
			// $('form #torrent_feed_id').val(feed_id);
			// $('#torrents td').effect('highlight');
			// $('html, body').animate({scrollTop: $("#torrents").offset().top - 100}, 2000);
		}
	});
	return false;
};


function torrent_details_hide() {
	$('#torrent_details').slideUp();
}
function torrent_details_show() {
	$('#torrent_details').slideDown();
}

// Torrent selection:
function torrent_handler(e) {
	// e.preventDefault();
	$('#torrents .success').removeClass('success');
	$(this).parent().addClass('success');
	var url = $(this).parent().data('href');
	console.log("Loading: " + url);
	$.ajax({
		url: url,
		success: function(data){
			$('#torrent_details').html(data);
			torrent_details_show();
		}
	});
	return false;
};
