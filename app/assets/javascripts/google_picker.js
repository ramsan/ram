google.load('picker', '1');

function createPicker(query) {
    return new google.picker.PickerBuilder().
    	setTitle('Find new image for memory').
        addView(new google.picker.ImageSearchView().setLicense(google.picker.ImageSearchView.License.NONE).setQuery(query)).
        enableFeature(google.picker.Feature.MULTISELECT_ENABLED).
        setCallback(pickerCallback).
        build();
}

function pickerCallback(data) {
   if(data.action == google.picker.Action.PICKED){
       for(var i=0; i < data.docs.length; i++){
       	   var google_img_div = $('#google_template .field').clone();
       	   //set thumb
       	   google_img_div.children('input.google_thumb').val(data.docs[i].thumbnails[0].url);
       	   //set main
       	   google_img_div.children('input.google_main').val(data.docs[i].thumbnails[1].url);
       	   //set img        	   
       	   google_img_div.children('img').attr('src', data.docs[i].thumbnails[0].url);
       	   //set description
       	   google_img_div.children('textarea').val(data.docs[i].description);
       	   //set page origin URL
       	   google_img_div.children('input.google_page_url').val(data.docs[i].url);
       	   
       	   // Append and display
       	   var display_div = $('#img_fields .content_box');
       	   display_div.append(google_img_div);
	  	   display_div.show();
       }	
   }
}