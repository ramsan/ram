$(document).ready(function(){
    $("#edit").click(function () {
        $("#memories_form").toggle("slow");
    });
    $('#comment_img img').live('load', function(){
        processImage($(this), 50, 50);
    });
    $('#comment_img img').live('change', function(){
        processImage($(this), 50, 50);
    });
    $('.list_comments imageComment img').each(function(){
        processImage($(this), 50, 50, 'inline');
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

	$('.file input[type=file]').bind('change focus click', imageUpload);
	
	$('span.remove').live('click', function(e){
		resetGoogleFields();
		resetUploadFields();
		resetExternalFields();
		$('#comment_img').html('');
	});
	
	$('a#external_link').click(function(e){
	    e.preventDefault();
	    var url = prompt("Please enter the image URL", 'http://');
        if(url!=null && url!=""){
            resetGoogleFields();
            resetUploadFields();
            
            $('input.external_url').val(url);
            
            $('#comment_img').html("<img src='"+url+"' />");
            processImage($('#comment_img img'), 70, 70, 'inline');            
            $('#comment_img').append("<span class='remove' title='Remove image'>X</span>");
        }
	});
	
	$('form#new_image input[type="submit"]').click(function(e){
	    e.preventDefault();
	    if($('form#new_image .commentDetails textarea').val().trim() == ''){
	        alert('Please add your comment');
	        return false;
	    }else{
	        $('form#new_image').submit();
	    }
	});

    $('form#edit_image input[type="submit"]').click(function(e){
        e.preventDefault();
        if($('form#edit_image .commentDetails textarea').val().trim() == ''){
            alert('Please add your comment');
            return false;
        }else{
            $('form#edit_image').submit();
        }
    });
});
function edit_commentjs(displayid){
    $(".commentform").removeClass("active");
    $(".commentform").hide("slow");
    if ($("#"+displayid).is(":visible")) {
        $("#"+displayid).hide("slow");
        $("#"+displayid).removeClass("active");
    }else{
        $("#"+displayid).show("slow");
        $("#"+displayid).addClass("active");
    }
}
function edit_imagebysearch(){
    var query = '';
    if(typeof(memory_name_var) == 'undefined'){
        query = $('#memory_name').val();
    }else{
        query = memory_name_var;
    }
    edit_Picker(query).setVisible(true);
}
function edit_remove_image(){
    resetGoogleFields();
    resetUploadFields();
    resetExternalFields();
    $('.active input.edit_google_thumb').val('');
    $('.active input.edit_google_main').val('');
    $('.active input.edit_google_page_url').val('');
    $('.active #edit_comment_img').html('');
}
function imageUpload(e){
	if($(this)[0].value !== ''){
		resetGoogleFields();
		resetExternalFields();		
	  	var file_name = $(this)[0].value.split('\\').pop();
	  	$('#comment_img').html('<span class="file_name">File: ' + file_name + '</span>');
	  	$('#comment_img').append(" <span class='remove' title='Remove image'>X</span>");
	}	
}

google.load('picker', '1');

function createPicker(query) {
    return new google.picker.PickerBuilder().
    	setTitle('Add image to comment').    	
        addView(new google.picker.ImageSearchView().setLicense(google.picker.ImageSearchView.License.NONE).setQuery(query)).
        setCallback(pickerCallback).
        build();
}
function edit_Picker(query) {
    return new google.picker.PickerBuilder().
        setTitle('Add image to comment').
        addView(new google.picker.ImageSearchView().setLicense(google.picker.ImageSearchView.License.NONE).setQuery(query)).
        setCallback(edit_pickerCallback).
        build();
}

function pickerCallback(data) {	
	if(data.action == google.picker.Action.PICKED){
		resetUploadFields();
		resetExternalFields();
		var i = 0;
		$('input.google_thumb').val(data.docs[i].thumbnails[0].url);
		$('input.google_main').val(data.docs[i].thumbnails[1].url);
		$('input.google_page_url').val(data.docs[i].url);
		$('#comment_img').html("<img src='"+data.docs[i].thumbnails[0].url+"' />");
		$('#comment_img').prepend("<span class='remove' title='Remove image'>X</span>");
    }
}

function edit_pickerCallback(data) {
    if(data.action == google.picker.Action.PICKED){
        resetUploadFields();
        resetExternalFields();
        var i = 0;
        $('.active input.edit_google_thumb').val(data.docs[i].thumbnails[0].url);
        $('.active input.edit_google_main').val(data.docs[i].thumbnails[1].url);
        $('.active input.edit_google_page_url').val(data.docs[i].url);
        $('.active #edit_comment_img').html("<img src='"+data.docs[i].thumbnails[0].url+"' />");
        $('.active #edit_comment_img').prepend("<span class='remove' title='Remove image'>X</span>");
    }
}

function resetUploadFields(){
	var new_file_field = $("<input type='file' name='images[][image]' id='comment_image_upload' />");
	$('#comment_image_upload').replaceWith(new_file_field);	
	new_file_field.bind('change focus click', imageUpload);
}

function resetGoogleFields(){
	$('input[type=hidden][class^="google_"]').removeAttr('value');	
}

function resetExternalFields(){
    $('input.external_url[type=hidden]').removeAttr('value');
}

function autoresize(id){
    $("#"+id+" #newUserComment").autoGrow();
}