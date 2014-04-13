$(function() {
	
	// Search feature.
  var delayed; 
  $('#search_form #search_query').keyup(function(event) { 
       clearTimeout(delayed); 
       var c= String.fromCharCode(event.keyCode);
       var isWordcharacter = c.match(/\w/);
       var value = this.value; 
       if ((event.keyCode == 46 || event.keyCode == 8 || isWordcharacter) && value && value.length > 2) { 
           delayed = setTimeout(function() { 
               $.get('/search', $.param({'q': value}), function(data, status, jxhr){
                 $('#search_results ul').replaceWith(data['html']);
              });
           }, 600); 
       } 
  });

	$('#search_form input').focusin(function() {
		console.log("Showing search results dialog.");
		$('#search_results').animate({
			right: '50px',
			top: '50px'
		});
	});
	
	$('#search_form input').focusout(function() {
		console.log("Hiding search results dialog.");
		$('#search_results').animate({
			right: '-800px',
			top: '-50px'
		});
	});


  $('#search_results').on('click', 'a', function(e){
    e.preventDefault();

    // Close the currently selected torrent details area, if present.
    $('#torrent_details').slideUp();
    
    feed_id = this.getAttribute('data-feed-id');
    torrent_id = this.getAttribute('data-torrent-id');
    url = $('.feed_link#feed_' + feed_id + ' td').first().data()['href'];
    console.log("Loading feed ID: " + feed_id);
    $('.success').removeClass('success');
    $(this).parent().addClass('success');
    $.ajax({
      url: url + '.json',
      success: function(data){
        $('#torrents table#feed_torrents tbody').replaceWith(data['torrent_html']);
        $('#torrents .btn.disabled').removeClass('disabled');
        $('form #torrent_feed_id').val(feed_id);
        $('#torrents td').effect('highlight');
        $('.torrent_link#torrent_' + torrent_id + ' td').click();
      }
    });
    return false;
  });

	
});
