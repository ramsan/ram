jQuery(document).ready(function($) {
	$("#hundred").numeric(false, function() { alert("Integers only"); this.value = ""; this.focus(); });
	$("#ten").numeric(false, function() { alert("Integers only"); this.value = ""; this.focus(); });
	$('#getIn').attr('disabled','disabled');
	$('input[type="text"][name="ten"], input[type="text"][name="unid"]').keyup(function(){
			if ($('input[name="ten"]').val() != "") {
				$(this).next('input').focus();
			};
	    if($('input[name="ten"]').val() != "" && $('input[name="unid"]').val() != ""){
        $('#getIn').removeAttr('disabled');
				$('#getIn').bind("click", function() {
					$("#birthYear").submit();
					return false;
				});
	    }
	    else{
				$('#getIn').attr('disabled','disabled');
	    }
	})
});


