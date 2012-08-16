$(function (){
	$('#add_menu_head').click(function(e){
	  e.preventDefault();
	  var $link = $(this).attr('href');
	  window.history.pushState('','',$link);
	  $('#loading_animation_container').show();

	  $('#new_memory_container').load($link+ " .newMemory", function(){
      $('#new_memory_lightbox').show();
      $('#loading_animation_container').hide();
	  });
	});
});