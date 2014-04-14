$(function() {

  $('#dashboard').on('click', '#feed-permissions form.permission input',function(){
    form = $(this).parents('form')
    form.find('input[name="user[role]"]:checked').val($(this).val());
    form.submit();
  });

});