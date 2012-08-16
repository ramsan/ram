jQuery(document).ready(function($) {
	function randomTime(data) {
	       var newTime = data[Math.floor(data.length * Math.random())];
	       return newTime;
	}

	function loadMoreFeeds() {
		var timeArray = new Array(6000, 4500, 2500, 3500, 2000, 5000, 2000, 2500, 7000);
		var reference = "'" + $('.feed_counter').attr('href') + "'";
		var page = reference.replace(/\D/g,'');

		$.ajax({
			url: '/feeds/next.js?feed=' + page,
			type: "GET",
		  success: function(data) {
		    // $('.result').html(data);
		  }
		});
    clearInterval(timer);
    timer = setInterval(loadMoreFeeds, randomTime(timeArray));
	}

	var timer = setInterval(loadMoreFeeds, 1000);
	// 1000 = Initial timer when the page is first loaded
});
