$(function(){
	$('ul#memorySlider') // Demo 2 code, using FX base effects 
  .anythingSlider({ 
		mode: "horiz",
		// easing: 'easeInOutBack',
		autoPlay: true,
   	resizeContents: false, 
		delay: 6500,      // How long between slideshow transitions in AutoPlay mode (in milliseconds) 
	  resumeDelay: 7500,
		buildArrows: false,
		infiniteSlides: true,
   // navigationFormatter : function(i, panel){ 
   //     return ['Recipe', 'Quote', 'Image', 'Quote #2', 'Image #2', 'Test'][i - 1]; 
   //    } 
  }) 
});


$(function(){
	$('ul#memoryBankSlider') // Demo 2 code, using FX base effects 
	  .anythingSlider({ 
			mode: "horiz",
			// easing: 'easeInOutBack',
			autoPlay: false,
	   	resizeContents: false, 
			delay: 6500,      // How long between slideshow transitions in AutoPlay mode (in milliseconds) 
		  resumeDelay: 7500,
			buildArrows: true,
			infiniteSlides      : true,
			onInitialized: function(e, slider) {
				if(img.height > img.width) {
				        img.height = '100%';
				        img.width = 'auto';
				} else {
	        img.width = '100%';
					img.height = 'auto';
				}
		  }
	   // navigationFormatter : function(i, panel){ 
	   //     return ['Recipe', 'Quote', 'Image', 'Quote #2', 'Image #2', 'Test'][i - 1]; 
	   //    } 
	  })
	  .anythingSliderFx({ 
	    // base FX definitions 
	    // '.selector' : [ 'effect(s)', 'size', 'time', 'easing' ] 
	    // 'size', 'time' and 'easing' are optional parameters, but must be kept in order if added 
	    '.memorySlider:first > *' : [ 'grow', '120px', '400', 'easeInOutCirc' ], 
	    '.memorySlide:last'      : [ 'top', '500px', '400', 'easeOutElastic' ], 
	    '.expand'               : [ 'expand', '10%', '400', 'easeOutBounce' ], 
	    '.textSlide h3'         : [ 'top fade', '200px', '500', 'easeOutBounce' ], 
	    '.textSlide img,.fade'  : [ 'fade' ], 
	    '.textSlide li'         : [ 'listLR' ] 
	});
});



