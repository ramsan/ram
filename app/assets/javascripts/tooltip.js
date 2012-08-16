/*-----------------------------------------------------------------------------------------------*/
/*                                      SIMPLE jQUERY TOOLTIP                                    */
/*                                      VERSION: 1.1                                             */
/*                                      AUTHOR: jon cazier                                       */
/*                                      EMAIL: jon@3nhanced.com                                  */
/*                                      WEBSITE: 3nhanced.com                                    */
/*-----------------------------------------------------------------------------------------------*/

$(document).ready(function() {
	$('.toolTip').hover(
		function() {
		this.tip = this.title;
		
		$(this).append(
			'<div class="toolTipWrapper">'
				+'<div class="toolTipContent">'
					+'<p>'
						+this.tip
					+'<p>'
				+'</div>'
			+'</div>'
		);
		// $(this).children('img').attr('title') = "";
		this.title = "";
		this.width = $(this).width();
		$(this).find('.toolTipWrapper').css({left:this.width-22})
		$('.toolTipWrapper').fadeIn(300);
	},
	function() {
		$('.toolTipWrapper').fadeOut(100);
		$(this).children('.toolTipWrapper').remove();
			this.title = this.tip;
		}
	);
});