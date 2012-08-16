jQuery(document).ready(function($) {

	$('#scrollToTop').hide();

  (function() {
    var page = 1,
        loading = false;

    function nearBottomOfPage() {
      return $(window).scrollTop() >= $(document).height() / 3 ;
    }
    
    function showTheScrollTopButton() {
      return $(window).scrollTop() > 400 ;
    }

    $(window).scroll(function(){
      if (loading) {
        return;
      }

      // if(nearBottomOfPage()) {
      //   loading=true;
      //   page++;
      //   $.ajax({
      //     url: '?page=' + page,
      //     type: 'get',
      //     dataType: 'script',
      //     success: function() {
      //       $('.pagination').hide();
      //       $('.endless'+page).find('img.preview').each(function(){  
      //         this.src = this.src}).load(function(){
      //           processImage($(this), 220, 198);
      //         });
      //         $(window).sausage('draw');
      //         $(".addToMyMemoryBank").draggable({ revert: true, helper: "clone", appendTo: '#memoryBankBox' });
      //       loading=false;
      //     }
      //   });
      // }
      if (showTheScrollTopButton()) {
      				$('#scrollToTop').fadeIn(650);
      			} else {
      				$('#scrollToTop').fadeOut(650);
      			}
    });
    $(window).sausage();
  }());
	
	$('form#new_vote input[type=radio]').live('change', function() {
		$('form input#voteShowdown').attr('disabled', false);
	});
});