$(document).ready(function() {

	$('a.panel').click(function () {
		$('a.panel').removeClass('selected');
		$(this).addClass('selected');
		current = $(this);
		$('#slider').scrollTo($(this).attr('href'), 800);		1
		return false;
	});
	
	/*

$('.navigation .logo img').css({
			"width":(menuWidth*0.7)
		})
		$('.navigation .buttons > div, .nav-arrow .prev, .nav-arrow .next, .navigation .logo').css({
			"width" : menuWidth,
			"height" : menuWidth
		});
		$('.navigation .buttons div').css({
			"height":menuWidth
		})
		$(".nav-arrow .next img, .nav-arrow .prev img").css({
			"height": menuWidth
		});
		$(".navigation .buttons div div").css({
			"margin-top": -1*(menuWidth-3)
		});	
		
		$(".nav-arrow .next img, .nav-arrow .prev img").hover(function(){
			$(this).css({
				"margin-left" : -1*menuWidth
			});
		},function(){
			$(this).css({
				"margin-left" : 0
			});	
		});
		$(".navigation .opacity").css("height",pages.length*height);
		$(".navigation .buttons div a").hover(function(){
			$(this).children('div').animate({
				left:menuWidth
			}, 300);
		},function(){
			$(this).children('div').animate({
				left: (menuWidth+150)*-1
			}, 300);
		})*/
});
