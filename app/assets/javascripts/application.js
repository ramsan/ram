// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// require jquery
//= require jquery_ujs
// require_tree .
//= require shadowbox/shadowbox

function resizeImage(ow, oh, nw, nh){
    	var h = nh;
	    var w = nw;
	    var l = 0;
	    if(oh == ow){
	    	if(nw != null){
	    		if( ow < nw ){
	    			w = nw;
	    			h = nw;
	    		} 
	    	}
	    }else if( ((ow > oh) && (nh != null)) || (nh == null) ){
	    	if(nh!=null){ 
	    		w = Math.ceil((ow / oh) * nh);
	    		h = nh;
	    	}else{
	    		w = Math.ceil((ow / ow) * nw);
	    		h = Math.ceil( w / ow * oh );
	    	}
	    	l = -(w-nw/2)+w/2;
	    }else if( ((ow < oh) && (nw != null)) || (nw == null) ){
	        if(nw!=null){ 
	        	h = Math.ceil( (oh / ow) * nw);
	        	w = nw; 
	        }else{
	        	h = Math.ceil(oh / oh * nh);
	        	w = Math.floor( h / oh * ow);
	        } 
	    }
	    var coords = new Array(); 
		coords["w"] = w; 
		coords["h"] = h;
		coords["l"] = l;
		return coords;
}

function processImage(target, w, h, pos){
	
	var css_position;
	if(typeof(pos) == "undefined"){
		css_position = 'absolute';
	}else{
		css_position = pos;
	}
	target.hide();
	var t = new Image();
	t.src = target.attr("src");
	var coords = resizeImage(t.width, t.height, w, h);
	
	target.css({ height: coords["h"], width: coords["w"], position: css_position, left: coords["l"] });
	target.show("fast");
}

var currentUserSelectorMessages = {
	'.post_comment_btn': 'post a comment',
	'a.remember_big_btn': 'remember this memory',
	'a.comment_big_btn': 'post a comment',
	'.is_following': 'follow this user',
	'#submit_memory_lnk': 'submit a memory',
	'.rembered_memory a': 'remember this memory',
	'#followUser input[type="submit"]': 'follow this user',
}

function setupDemos() {
	Shadowbox.setup("a.media", {
		gallery: "Additional Photos",
		continuous: true,
		counterType: "skip"
	});
}

$(document).mouseup(function (e)
{
    var container = $(".nav_user");
		var upper = $('#user-name');
    if (container.has(e.target).length === 0 && container.is(':visible'))
    {
        // container.hide();
				container.slideToggle('fast');
				// container.removeClass("user_menu").addClass("user_menu open_user_arrow");
				$(".user_menu").removeClass("user_menu open_user_arrow").addClass("user_menu");

		}
});

var counter = 0
function countdown() {
	var s = $('.showdownCountDown');
  var reference = "'" + $('#skip_showdown a').attr('href') + "'";
	var nextShowdown = reference.replace(/\D/g,'');
	if(parseInt(s.html()) == 0) {
		clearInterval(counter);
		$('#autoLoadingShowdown').remove();
		$.ajax({
			url: '/voting/next_vote.js?showdown=' + nextShowdown,
			type: "GET",
		  success: function(data) {
		    // console.log("fired");
		  }
		});

    // console.log('Complete.');
  }
  s.html(parseInt(s.html()-1));
}

// var submitForm = false;
// //Do some form validation and set the var submitform to true or false
// if (submitForm == true) {
//   $('input[type=submit]').attr('disabled', true);
//   form.submit();
// }else{
//   return false;
// }


$(document).ready(function(){
	$('input[type=submit]').click(function(){
	  // $('input[type=submit]').attr("disabled", true);  
	});
	$('#iAmNotLoggedIn').click(function() {
	  // alert("Hi");
	});

	$(":input[placeholder]").placeholder();

	$('.notice').delay(2500).fadeOut(1500);
	//var config = {"opacity": 40,"position": "topleft","path": "/images/mask.png"};
	//$(document).watermark(config);
	// open acordeon
      $(".accordion_btn").click(function(){
        var _this = $(this);
        $(this).next().slideToggle("fast", function() {
        
          if($(this).parent().find(".accordeon_cont").is(':visible')){
            _this.removeClass("accordion_btn").addClass("accordion_btn open");
          }else{
            _this.removeClass("accordion_btn open").addClass("accordion_btn");
          }
         $('.memories_list').masonry( 'reload' ); 
        });
      });
	$.each(currentUserSelectorMessages, function(selector, action) {
		$(selector).live('click', function(){
			return pleaseLogInOrRegister(action);
		});
	});
	
	$('#search_btn').click(function(e){
	  e.preventDefault();
	  if($('#search_term').val().trim() != ''){
	    $(this).parent('form').submit();
	  }else{
	    alert('Please indicate a term or terms to search');
	  }    
	});
	
	$('a#choose_category').click(function() {
        $('.categories').slideToggle('slow', function() {
          // $('#view_latest').children('.title').removeClass('on');
          //           $('#view_latest').children('.description').removeClass('on');
					$('li.memoriesCounter').addClass('activeTab');
          $('#view_most_popular').children('.title').removeClass('on');
          $('#view_most_popular').children('.description').removeClass('on');
          $('#choose_category').children('.title').addClass("on");
          $('#choose_category').children('.description').addClass("on");
          // Animation complete.
        });
    });
    $(".hide_category_list").click(function() {
      $('.categories').slideToggle('slow', function() {
          // Animation complete.
      });
    });
    
    $(".hide_welcome_message").click(function() {
      $('#welcome-to-do-you-remember').fadeOut('slow', function() {
          // Animation complete.
      });
    });

    $('.select_category_btn').click(function() {
    	
        $('.select_form').slideToggle('fast', function() {
        	
        });
    });
        
    $('.close_search').click(function() {
    	var _this = $('.search_btn');
        $('.search_cont').slideToggle('fast', function() {
        	_this.removeClass("btn menu search_btn bgyellow").addClass("btn menu search_btn");
        });
    });
    
    $('.search_btn').click(function() {
    	var _this = $(this);
        $('.search_cont').slideToggle('fast', function() {
        	
          if($(this).is(':visible')){
          	//btn menu search_btn
          	_this.removeClass("btn menu search_btn").addClass("btn menu search_btn bgyellow");
          }else{
          	_this.removeClass("btn menu search_btn bgyellow").addClass("btn menu search_btn");
          }
          
        });
    });
    
    $('.info').click(function() {
    	var _this = $(this);
        $('.nav_about_user').slideToggle('fast', function() {
          
        });
    });
    
    $('.user_menu').click(function() {
    	var _this = $(this);
        $('.nav_user').slideToggle('fast', function() {
          if($(this).is(':visible')){
          	_this.removeClass("user_menu").addClass("user_menu open_user_arrow");
          }else{
          	_this.removeClass("user_menu open_user_arrow").addClass("user_menu");
          }
        });
    });
		
		$('#moreOptions').click(function() {
    	var _this = $(this);
        $('.more_nav').slideToggle('fast', function() {
          if($(this).is(':visible')){
          	_this.addClass("open_user_arrow");
          }else{
          	_this.removeClass("open_user_arrow");
          }
        });
    });
    
  // $(".more").click(function(){
  //  // var memory_box = $(this).parent().parent().parent().parent().find(".tab_box");
  //     var memory_box = $(this).parent().parent().find(".tab_box");
  //  var box_text = $(this).children('span');
  //  if (box_text.text() == 'More'){
  //    box_text.text('Less');
  //  }else{
  //    box_text.text('More');
  //  }
  //  memory_box.slideToggle("blind", null, 500);
  //  memory_box.find(".tabs").tabs({
  //    spinner: "<img src='/images/loader.gif' />",
  //          load: function(event, ui) { 
  //            $(this).find("span.spinner").hide();
  //            openTabs();
  //    }
  //      });
  //  return false;
  // })

  $(".bmore, .bcomments-count, .bi-remembers, .buser-photos, .brelated, .brelatedPhotos").click(function(){
     // var memory_box = $(this).parent().parent().parent().parent().find(".tab_box");
     var memory_box = $(this).parent().find(".tab_box");
     var box_text = $(this).closest('.bmore');
			console.log(box_text);
     if (box_text.text() == 'MORE'){
       box_text.text('LESS');
     }else{
       box_text.text('MORE');
     }
     memory_box.slideToggle("blind", null, 500);
     memory_box.find(".tabs").tabs({
       spinner: "<img src='/images/loader.gif' />",
             load: function(event, ui) { 
               $(this).find("span.spinner").hide();
               openTabs();
       }
         });
     return false;
    })

  //  	$('img.preview').each(function(){
  //  		this.src = this.src}).load(function(){
	 // 	processImage($(this), 180, 180);
		// });
	
		$('img.showdownPreview').each(function(){
   		this.src = this.src}).load(function(){
	 	processImage($(this), 140, 140);
		});

		$('img.showdownContentPreview').each(function(){
				this.src = this.src}).load(function(){
					processImage($(this), 140, 140);
		});
		
		$('.feedBackMemory .image img').each(function(){
				this.src = this.src}).load(function(){
					processImage($(this), 65, 65);
		});

		$('.is_following.green').live('click', function(){
    	var class_arr, user_id;
    	class_arr = $(this).attr('class').split(' ');
    	$.each(class_arr, function(index, value) {
    		if(value.match(/^following_/)){
  				user_id = value.split('_')[1];
  				return false;
  			}
		});
		$.get('/previews/' + user_id + '/unfollow');
    });
    
    $('.is_following.grey').live('click',function(){
    	var class_arr, user_id;
    	class_arr = $(this).attr('class').split(' ');
    	$.each(class_arr, function(index, value) {
    		if(value.match(/^not-following_/)){
  				user_id = value.split('_')[1];
  				return false;
  			}
		});
		$.get('/previews/' + user_id + '/follow');
    });
    
    Shadowbox.init({
		overlayOpacity: 0.8
	}, setupDemos);
	
	$('input[type="submit"].post_comment_btn').live('click',function(e){
		e.preventDefault();
		if(!current_user) return false;
		var this_form = $(this).parent('form');
		if(this_form.children('textarea').val() == ''){
			alert('Please write a comment');
		}else{
			this_form.submit();
		}
	});
	$('.remove[data-memory-id]').click(function(){
		if(confirm('Are you sure you want to delete this Memory?')){
			$('body').addClass('busy');
			$(this).css('cursor','wait');
			$.get('/previews/' + $(this).attr('data-memory-id') + '/delete');
		}
	});

	// Turned off memory bank for now
	// $('#memoryBankToggle').click(function() {
	// 		$("#memoryBankBox").toggleClass('minimized', 500); 
	// 		if ($("#memoryBankToggleStatusImage").attr("src") ==  "/assets/memoryBankButtonClose.png") {
	// 			$("#memoryBankToggleStatusImage").attr("src", "/assets/memoryBankButtonOpen.png");
	// 			$(".addToMyMemoryBank").draggable({ helper: "clone", appendTo: '#memoryBankBox', disabled: false });
	// 			$(".memoryBankSliderSection").draggable({ helper: "clone", appendTo: '#memoryBankBox', disabled: false });
	// 		} else {
	// 			$("#memoryBankToggleStatusImage").attr("src", "/assets/memoryBankButtonClose.png");
	// 			$(".addToMyMemoryBank").draggable({ helper: "clone", appendTo: '#memoryBankBox', disabled: true });
	// 		}
	// });	
	
	$('#scrollToTop img').click(function() {
		$('body,html').animate({
			scrollTop: 0
			}, 450, function() {
				$('#scrollToTop').fadeOut();
				// Animation complete.
		  	});
		});
	
	$('#memoryBankBox').droppable({
		accept: ".addToMyMemoryBank",
		activeClass: "ui-state-hover",
		hoverClass: "ui-state-active",
		tolerance: "touch",
		drop: function( event, ui ) {
			var memory = $(ui.draggable).attr("id");
			var id = memory.replace('memory_', '');
			$.get('/memories/add-to-memory-bank?id='+id, function(data) {
			  // $('.result').html(data);
			});
		} 
	});
	$('.memoryBankOptions').click(function(event) {
		// Act on the event
	});		
	
	counter = setInterval('countdown()',1000);
	
	// $('#voting_showdown').children('*:radio').prop('checked', false);
	$('#voting_showdown *:radio').live('change', function() { 
		$('#voting_showdown *:radio').prop('checked', false).val('0');
		$(this).prop('checked', true).val('1').show();
	});
	
	$('#showdownVote').live('mouseenter', function() {
		clearInterval(counter)
		$('.showdownCountDown').addClass('blinking');
		// $('#autoLoadingShowdown').addClass('hidden');
		// 		$('#autoLoadingShowdownPaused').removeClass('hidden');
	});

	$('#showdownVote').live('mouseleave', function() {
		clearInterval(counter)
		$('.showdownCountDown').removeClass('blinking');
		// $('#autoLoadingShowdown').removeClass('hidden');
		// 		$('#autoLoadingShowdownPaused').addClass('hidden');
		counter = setInterval('countdown()',1000);
	});

});	



// $(function() {
// 	//http://caroufredsel.frebsite.nl/
// 	//carousel footer	
// 	if($('#list_users').length){
// 		$('#list_users').carouFredSel({
// 			next: '#prev',
// 			prev: '#next',
// 			scroll: {
// 		        onAfter: function( oldItems, newItems, newSizes ) {	
// 		            $('.cont_carousel').width($(".caroufredsel_wrapper").width());
// 		        }
//     		},
// 			auto: false
// 		});
// 	}	
// });

function five_words_or_less(str){
	var stripped_str = jQuery.trim(str);
	if(stripped_str == '') return false; 
	var word_count = stripped_str.split(' ').length;
   	return (word_count > 0 && word_count < 6 ? true : false)
}

function pleaseLogInOrRegister(toPerform){
	if(!current_user){
		alert('Please login or register to ' + toPerform);
		return false;
	}else{
		return true;
	}
}
      

function openTabs(){    	
	//resize related images
	
	$('.img_memory_related img').each(function(){  
   		this.src = this.src}).load(function(){
	 	processImage($(this), 30, 30);
	});
	
	//resize related images
	
	$('.img_memory_remembered img').each(function(){  
   		this.src = this.src}).load(function(){
	 	processImage($(this), 40, 40);
	});
	
	//resize memory photo
	
	$('.img_memory_photo img').each(function(){  
   		this.src = this.src}).load(function(){
	 	processImage($(this), 65, 65);
	});
	
	//resize image profile
	
	$('.img_profile img').each(function(){  
   		this.src = this.src}).load(function(){
	 	processImage($(this), 30, 30);
	});
	
}