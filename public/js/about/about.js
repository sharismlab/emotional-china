$(document).ready(function() {

	$('a.panel').click(function () {
		$('a.panel').removeClass('selected');
		$(this).addClass('selected');
		current = $(this);
		$('#slider').scrollTo($(this).attr('href'), 800);		1
		return false;
	});
	
});
