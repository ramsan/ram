// $(function(){
// 	$.toggle_mem_button = function () {
// 		var $button = $('#remember_this_block a');
// 		if ($('#remember_this_block a').hasClass('iRememberedThis')){
// 			$button.mouseenter(function(){
// 				$(this).html('Remove from my memories');
// 				//$(this).css('background-color', 'red');
// 			});
// 			$button.mouseleave(function(){
// 				$(this).html('I remember this');
// 				//$(this).css('background-color', 'blue');
// 			});
// 		}
// 	};

// 	$('.option_button').click(function(){
// 		//alert();
// 		$('.option').hide();
// 		$('.option_button').removeClass('open_tab');
// 		$($(this).attr('href')).show();
// 		$(this).addClass('open_tab');

// 	});
// 	$('#remember_this_block a').click(function(){
// 		$(this).toggleClass('iRememberedThis');
// 		$(this).toggleClass('remember_button');
// 		//$.toggle_mem_button();
// 	});
// 	//$.toggle_mem_button();

// 	$('#image_slideshow').anythingSlider({
// 		buildStartStop: false,
// 		resizeContents: false,
// 		mode: "vertical"
// 	});
// });