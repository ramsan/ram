$(document).ready(function(){
	$('#memory_date_of_memory').datepicker({
      showOn: "both",
      buttonImage: "/assets/calendar.gif",
      buttonImageOnly: true,
      changeMonth: true,
      changeYear: true,
			defaultDate: '-20y',
      maxDate: '+0y',
      yearRange: '-70:+0',
      constrainInput: true,
      dateFormat: 'yy-mm-dd'
    });
	$('a#search_link').click(function(e){
		e.preventDefault();
		var query = '';
		if(typeof(memory_name_var) == 'undefined'){
			query = $('#memory_name').val();
		}else{
			query = memory_name_var;
		}
		createPicker(query).setVisible(true);
	});
	
	// Validate memory form submission
	$('#create_memory_btn').click(function(e){
	    $('#create_memory_btn').attr('disabled', true);
		e.preventDefault();
		var errors = [];
		if($('#memory_name').val() == ''){ 
			errors.push('Please indicate a Name');
		}else{
			if($('#memory_name').val().length > 60) errors.push('Please use less than 60 characters for your Memory name');			
		}
		if(!$('input[name="memory[category_ids][]"]').is(':checked'))errors.push('Please choose a Category for this memory');
		if($('#img_fields .field').length == 0 && $('.memories_list').find('a[id^="img_"]').length == 0) errors.push('Please search for or upload at least one image for this memory');
		if(errors.length > 0){
			alert(errors.join("\n\n"));
			$('#create_memory_btn').attr('disabled', false);
		}else{
			$(this).parents('form:first')[0].submit();
		}
	});

	$('.file input[type=file]').bind('change focus click', imageUpload);
	
	$('span.remove').live('click', function(e){
		$(this).parent('.field:first').remove();
		var display_div = $('#img_fields .content_box');
		if(display_div.find('.field').length == 0) display_div.hide();
	});
	
	$('span.remove_img').click(function(e){
		e.preventDefault();
		// if($(this).parents('.memories_list:first').find('a[id^="img_"]').length <= 1){
		// 			alert('You cannot delete the only image for a memory');
		// 			return false;
		// 		}
		if(confirm('Are you sure you want to delete this image?')){
			$.ajax({
   				url: '/images/' + $(this).attr('data-id'),
   				type: 'DELETE',
   				xhrFields: {
      				authenticity_token: $('meta[name="csrf-token"]'),
      				utf8: "&#x2713;"
   				}
			});			
		}
	});
	
	$('a#external_url_link').click(function(e){
	    e.preventDefault();
	    var url = prompt("Please enter the image URL", 'http://');
	    if(url!=null && url!=""){
	        var external_img_div = $('#external_template .field').clone();
	        //set main
            external_img_div.children('input.external_url').val(url);
            //set img               
            external_img_div.children('img').attr('src', url);
            
            // Append and display
            var display_div = $('#img_fields .content_box');
            display_div.append(external_img_div);
            display_div.show();
	    }
	});
	
	$('#close_select_category').click(function(){
		$('.select_category_btn').click();
	});
});

function imageUpload(e){
	if($(this)[0].value !== ''){
		// clone content of #img_template & append to #img_fields
	  	var new_upload_div = $('#img_template .field').clone();
	  	var display_div = $('#img_fields .content_box');
	  	display_div.append(new_upload_div);
	  	display_div.show();
	  	
	  	// move image upload field to new div's .img_hidden
	  	$($(this)[0]).appendTo(new_upload_div.find('.img_hidden'));
	  	
	  	// create new image upload field
	  	var new_upload_field = $("<input name='memory[images_attributes][][image]' type='file'>");
	  	new_upload_field.bind('change focus click', imageUpload);
	  	new_upload_field.appendTo('span.file');
	  	
	  	// display stuff
	  	var file_name = $(this)[0].value.split('\\').pop();
	  	new_upload_div.find('span.file_name').html('File: ' + file_name);
	}	
}

