$(document).ready(function() {
	$(":input[placeholder]").placeholder();
	// Stuff to do as soon as the DOM is ready;
	$('#container').draggable({ containment: "parent" });
	
	if ($('input#avatar_choice').val().length > 0) {
		var selected_avatar;
		var selected_avatar = $('input#avatar_choice').val();
		$("a[id^='" + selected_avatar + "']").addClass('on');
	}
	
	
	$('a.avatar').click( function()	{
		image = $(this).attr("id");
		// $("#avatar_choice").val(image);
		if ($("#avatar_choice").val() == image) {
			$("#avatar_choice").val('');
			$('.avatar').removeClass('on');
		} else {
			$("#avatar_choice").val(image);
			$('.avatar').removeClass('on');
			$(this).addClass('on');
		};
	});
	
	$('a#with_email').click(function() {
		$('#withOptions').fadeOut('slow', function() {
		    $('#withOptions').addClass("hidden");
		});
		$('#manually').fadeIn('slow', function() {
			$('#manually').removeClass("hidden");
		});
	});
	// $('#manually').removeClass("hidden");
	
	// cache references to the input elements into variables
  var passwordField = $('input[id=user_password]');
	var confirmationPasswordField = $('input[id=user_password_confirmation]');
  // get the default value for the email address field

  // add a password placeholder field to the html
  passwordField.after('<input id="passwordPlaceholder" type="text" value="Password" autocomplete="off" />');
	confirmationPasswordField.after('<input id="confirmationPasswordPlaceholder" type="text" value="Password confirmation" autocomplete="off" />');
  var passwordPlaceholder = $('#passwordPlaceholder');
	var confirmationPasswordPlaceholder = $('#confirmationPasswordPlaceholder');

  // show the placeholder with the prompt text and hide the actual password field
  passwordPlaceholder.show();
  passwordField.hide();

	confirmationPasswordPlaceholder.show();
  confirmationPasswordField.hide();

  // when focus is placed on the placeholder hide the placeholder and show the actual password field
  passwordPlaceholder.focus(function() {
      passwordPlaceholder.hide();
      passwordField.show();
      passwordField.focus();
  });
	
	confirmationPasswordPlaceholder.focus(function() {
      confirmationPasswordPlaceholder.hide();
      confirmationPasswordField.show();
      confirmationPasswordField.focus();
  });

  // and vice versa: hide the actual password field if no password has yet been entered
  passwordField.blur(function() {
      if(passwordField.val() == '') {
          passwordPlaceholder.show();
          passwordField.hide();
      }
  });


	confirmationPasswordField.blur(function() {
      if(confirmationPasswordField.val() == '') {
          confirmationPasswordPlaceholder.show();
          confirmationPasswordField.hide();
      }
  });
	
});
