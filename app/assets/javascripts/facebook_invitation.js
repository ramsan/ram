$(document).ready(function() {
	
	$('input#submit_facebook').bind('click', function() {
		// $('input#submit_facebook').attr('disabled', false);
		$("#fb_friends_form").submit();
		return false;
	});
	
  var h = 0;  var _lastn = 0;
  $('.fb_friend').css("opacity", 0);
  $('.fb_friend').each(function(index) {
      _class = $(this).attr("class");
      _class.split(" ");
      _n = _class[3];
      if(_n != _lastn){ 
        $('.facebook_friends_cont').height(h + 20);
        h = 0; 
      }
      $(this).css("top", h += 20 );
     _lastn = _class[3];
  });
  $('.fb_friend').css("opacity", 1);
  $('a#fb_all').click(function(e){
    e.preventDefault();
    if($(this).text() == 'Check all'){
      $('#fb_friends_form input[type="checkbox"]').attr('checked', true);
      $(this).text('Un-check all');
    }else{
      $('#fb_friends_form input[type="checkbox"]').attr('checked', false);
      $(this).text('Check all');
    }
  });
});
