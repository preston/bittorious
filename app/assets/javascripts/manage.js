$(function() {

  $('#manage').on('ajax:success', 'form.approve', function(data, status, xhr) {
    if (status['approved'] == true) {
      approved_row = $(status['html']);
      approved_row.hide();
      $('tbody#approved_users').append(approved_row);
      approved_row.fadeIn();
      row = $(this).parents('tr');
      row.fadeOut();
      row.remove();
    }
  });

  $('#manage').on('ajax:success', 'form.deny', function(data, status, xhr) {
    if (status == true) {
      row = $(this).parents('tr');
      row.fadeOut();
      row.remove();
    }
  });

  $('#manage').on('click', 'form.user input',function(){
    form = $(this).parents('form')
    form.find('input#user_admin').val($(this).val());
    form.submit();
  });

});