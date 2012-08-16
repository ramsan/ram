$(function(){
  $.masonry_load = function () {

    var $container = $('.memories_list');

    $container.imagesLoaded( function(){
      $container.masonry({
        // options
        itemSelector : '.memory_box',
        isFitWidth: true,
        isAnimated: true
      });

      // sets popup on left and right edges to fit in the container
      var column_width = 66; 
      $('.small_memory').each(function(){
        if ($(this).css('left') === '0px'){
          $(this).children('.memory_bigger').css('left', '0px');
        }
        if ($(this).css('left') === ( ($container.width() - column_width) + 'px' )){
          $(this).children('.memory_bigger').css('left', '-112px' );
        }
        if ($(this).css('top') === '0px')
          $(this).children('.memory_bigger').css('top', '0px' );
      });
      $('#loading_animation_container').hide();
    });

    $container.infinitescroll({
      navSelector   : "nav.pagination",            
      nextSelector  : "span.next a",    
      itemSelector  : ".memory_box",          
      bufferPx      : 1000,
      loadingImg    : ''
      }, function( newElements ) {
        $('#loading_animation_container').show();
        // hide new items while they are loading
        var $newElems = $( newElements ).css({ opacity: 0 });
        // ensure that images load before adding to masonry layout
        $newElems.imagesLoaded(function(){
          // show elems now they're ready
          $newElems.animate({ opacity: 1 });
          $container.masonry( 'appended', $newElems, true );
          $('#loading_animation_container').hide();
        }
      );
    });
    
    // $('a.memory_link, a.memory_list').address(function() {  
    //   return $(this).attr('href');  
    // });  

    $('a.memory_link, a.memory_list').click(function(e){
      e.preventDefault();
      var $mem_link = $(this).attr('href');
      window.history.pushState('','',$mem_link);
      if ($(this).hasClass('inner_link')){
        var $memory_biggest = $(this).parent().parent().find('.memory_full_lightbox');
      } else {
        var $memory_biggest = $(this).parent().find('.memory_full_lightbox');
      }
      $('#loading_animation_container').show();
      $memory_biggest.children('#memory_full').load($mem_link + " .memory", function(){
        
        $memory_biggest.imagesLoaded(function(){
          $.getScript("http://w.sharethis.com/button/buttons.js");
          $memory_biggest.show();
          $('#loading_animation_container').hide();

          // need to call these from somewhere else
          $('.option_button').click(function(){
            $('.option').hide();
            $('.option_button').removeClass('open_tab');
            $($(this).attr('href')).show();
            $(this).addClass('open_tab');
          });
          $('#image_slideshow').anythingSlider({
            buildStartStop: false,
            resizeContents: false,
            hashTags: false,
            mode: "vertical"
          });
          $('.option_button').live('click',function(){
            $('.option').hide();
            $('.option_button').removeClass('open_tab');
            $($(this).attr('href')).show();
            $(this).addClass('open_tab');
            if ( $(this).attr('href') === '#comment' ) {
              $('#new_comment').css('visibility', 'visible');
            } else {
              $('#new_comment').css('visibility', 'hidden');
            }
          });
        });
      });
    });
    
    //sets menu header to add active year/tag name
    var $menu_head = $('a.selected');
    if ($menu_head.attr('id') === 'year_menu_head'){
      var $title = $('#decade_timeline a.current');
    }
    if ($menu_head.attr('id') === 'tag_menu_head'){
      var $title = $('#tag_box a.current');
    }
    if ($menu_head.hasClass('selected')){
      $('.menu_head').children('.status_hook').html('');
      if ($title.hasClass('decade') || $title.hasClass('tag') ){
        $menu_head.children('.status_hook').html(': ' + $title.html());
      }
    }

    $('#memories_list,').children('nav.pagination').css('visibility', 'hidden');
    $('.header_menu').hide();
    $('.selected').removeClass('selected');

    //two ways of closing the lightbox:
    $('.memory_full_lightbox , #new_memory_lightbox').click(function (e){

      if ($(this).has(e.target).length === 0){
        e.preventDefault();
        $(this).find('.memory, .newMemory').remove();
        $(this).hide(0, function(){
          window.history.pushState('','','/');
        });
      }
    });
    $('a.close').click(function(e){
      e.preventDefault();
      window.history.pushState('','','/');
      $(this).parent().find('.memory').remove();
      $(this).parent().hide();
    });
  };

  /////

  $('#loading_animation_container').show();
  $.masonry_load();

  $('a.menu_head').click(function(e){
    if (!$(this).hasClass('sign_in')){ //sign in lightbox not yet implemented
      e.preventDefault();
      var $data = '#' + $(this).attr('data_id');
      if ($(this).hasClass('user_menu_hook')){
        $($data).toggle();
      } else {
        if ($(this).hasClass('selected')) {
          $(this).removeClass('selected');
          $($data).hide();
        } else {
          $(this).parent().find('a').removeClass('selected');
          $('#popdown_menus').children('.header_menu').hide();
          $($data).show();
          $(this).addClass('selected');
        }
      }
    }
  });

  $('#home_index #decade_timeline a, #home_index #tag_box a').on('click',function(e){
    var $title = $(this).html();
    $(this).parent().find('a').removeClass('current');
    $(this).addClass('current');
      $('#loading_animation_container').show();
    $.getScript(this.href, function(){
      $.masonry_load();
    });
    e.preventDefault();
  });

});