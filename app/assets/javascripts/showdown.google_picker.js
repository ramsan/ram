google.load('picker', '1');
// 

// Creating Google Searcher For Memory 1
function createPicker1(query) {
  return new google.picker.PickerBuilder().
  	setTitle('Find new image for memory 1').
      addView(new google.picker.ImageSearchView().setLicense(google.picker.ImageSearchView.License.NONE).setQuery(query)).
      setCallback(pickerCallback1).
      build();
}
function pickerCallback1(data) {
  var url;
	var thumb;
  if (data[google.picker.Response.ACTION] == google.picker.Action.PICKED) {
    var doc = data[google.picker.Response.DOCUMENTS][0];
		// Getting the URL
    url = doc[google.picker.Document.URL];
		$('input.image_1_google_page_url').val(url);

		// Getting the thumbnail
		thumb = doc.thumbnails[0].url;
		$('input.image_1_google_thumb').val(thumb);

		// Getting the main image
		main = doc.thumbnails[1].url;
		$('input.image_1_google_main').val(main);

		// Presenting the preview of the searched image
		$('#image_m1').children('img').attr('src', main);
	
		$('#image_m1').children('img').load(function(){
			processImage($(this), 160, 160);
		});
	
  }
}

// Creating Google Searcher For Memory 2
function createPicker2(query) {
  return new google.picker.PickerBuilder().
  	setTitle('Find new image for memory 2').
      addView(new google.picker.ImageSearchView().setLicense(google.picker.ImageSearchView.License.NONE).setQuery(query)).
      setCallback(pickerCallback2).
      build();
}
function pickerCallback2(data) {
  var url;
	var thumb;
  if (data[google.picker.Response.ACTION] == google.picker.Action.PICKED) {
    var doc = data[google.picker.Response.DOCUMENTS][0];

		// Getting the URL
    url = doc[google.picker.Document.URL];
		$('input.image_2_google_page_url').val(url);

		// Getting the thumbnail
		thumb = doc.thumbnails[0].url;
		$('input.image_2_google_thumb').val(thumb);

		// Getting the main image
		main = doc.thumbnails[1].url;
		$('input.image_2_google_main').val(main);

		// Presenting the preview of the searched image
		$('#image_m2').children('img').attr('src', main);
	
		$('#image_m2').children('img').load(function(){
			processImage($(this), 160, 160);
		});
		
  }
}

// Creating Google Searcher For Memory 3
function createPicker3(query) {
  return new google.picker.PickerBuilder().
  	setTitle('Find new image for memory 3').
      addView(new google.picker.ImageSearchView().setLicense(google.picker.ImageSearchView.License.NONE).setQuery(query)).
      setCallback(pickerCallback3).
      build();
}
function pickerCallback3(data) {
  var url;
	var thumb;
  if (data[google.picker.Response.ACTION] == google.picker.Action.PICKED) {
    var doc = data[google.picker.Response.DOCUMENTS][0];

		// Getting the URL
    url = doc[google.picker.Document.URL];
		$('input.image_3_google_page_url').val(url);

		// Getting the thumbnail
		thumb = doc.thumbnails[0].url;
		$('input.image_3_google_thumb').val(thumb);

		// Getting the main image
		main = doc.thumbnails[1].url;
		$('input.image_3_google_main').val(main);

		// Presenting the preview of the searched image
		$('#image_m3').children('img').attr('src', main);
	
		$('#image_m3').children('img').load(function(){
			processImage($(this), 160, 160);
		});
		
  }
}

// Creating Google Searcher For Memory 4
function createPicker4(query) {
  return new google.picker.PickerBuilder().
  	setTitle('Find new image for memory 4').
      addView(new google.picker.ImageSearchView().setLicense(google.picker.ImageSearchView.License.NONE).setQuery(query)).
      setCallback(pickerCallback4).
      build();
}
function pickerCallback4(data) {
  var url;
	var thumb;
  if (data[google.picker.Response.ACTION] == google.picker.Action.PICKED) {
    var doc = data[google.picker.Response.DOCUMENTS][0];

		console.log(doc);
		// Getting the URL
    url = doc[google.picker.Document.URL];
		$('input.image_4_google_page_url').val(url);

		// Getting the thumbnail
		thumb = doc.thumbnails[0].url;
		$('input.image_4_google_thumb').val(thumb);

		// Getting the main image
		main = doc.thumbnails[1].url;
		$('input.image_4_google_main').val(main);

		// Presenting the preview of the searched image
		$('#image_m4').children('img').attr('src', main);
	
		$('#image_m4').children('img').load(function(){
			processImage($(this), 160, 160);
		});
		
  }
}

// Creating Google Searcher For Memory 5
function createPicker5(query) {
  return new google.picker.PickerBuilder().
  	setTitle('Find new image for memory 5').
      addView(new google.picker.ImageSearchView().setLicense(google.picker.ImageSearchView.License.NONE).setQuery(query)).
      setCallback(pickerCallback5).
      build();
}
function pickerCallback5(data) {
  var url;
	var thumb;
  if (data[google.picker.Response.ACTION] == google.picker.Action.PICKED) {
    var doc = data[google.picker.Response.DOCUMENTS][0];

		// Getting the URL
    url = doc[google.picker.Document.URL];
		$('input.image_5_google_page_url').val(url);

		// Getting the thumbnail
		thumb = doc.thumbnails[0].url;
		$('input.image_5_google_thumb').val(thumb);

		// Getting the main image
		main = doc.thumbnails[1].url;
		$('input.image_5_google_main').val(main);

		// Presenting the preview of the searched image
		$('#image_m5').children('img').attr('src', main);
	
		$('#image_m5').children('img').load(function(){
			processImage($(this), 160, 160);
		});
		
  }
}
