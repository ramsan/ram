$(document).ready(function() {
	$("#showdownQuestion").charCount({
    allowed: 60,
    warning: 0,
    counterText: ''
  });
	$(".showdownMemoryName").charCount({
    allowed: 18,
    warning: 0,
    counterText: ''
  });
	$('a#search_link1').click(function(e){
		e.preventDefault();
		var query = '';
		if(typeof(memory_1_name_var) == 'undefined'){
			query = $('#memory_1_name').val();
		}else{
			query = memory_1_name_var;
		}
		createPicker1(query).setVisible(true);
	});
	$('a#search_link2').click(function(e){
		e.preventDefault();
		var query = '';
		if(typeof(memory_2_name_var) == 'undefined'){
			query = $('#memory_2_name').val();
		}else{
			query = memory_2_name_var;
		}
		createPicker2(query).setVisible(true);
	});
	$('a#search_link3').click(function(e){
		e.preventDefault();
		var query = '';
		if(typeof(memory_3_name_var) == 'undefined'){
			query = $('#memory_3_name').val();
		}else{
			query = memory_3_name_var;
		}
		createPicker3(query).setVisible(true);
	});
	
	$('a#search_link4').click(function(e){
		e.preventDefault();
		var query = '';
		if(typeof(memory_4_name_var) == 'undefined'){
			query = $('#memory_4_name').val();
		}else{
			query = memory_4_name_var;
		}
		createPicker4(query).setVisible(true);
	});
	
	$('a#search_link5').click(function(e){
		e.preventDefault();
		var query = '';
		if(typeof(memory_5_name_var) == 'undefined'){
			query = $('#memory_5_name').val();
		}else{
			query = memory_5_name_var;
		}
		createPicker5(query).setVisible(true);
	});
});