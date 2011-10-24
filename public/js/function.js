// JavaScript Document

$(function(){

	//div position
	$('.footer').css('margin-left',($(window).width()-$('.footer').width())/2);
	$('.signbox').css('left',($(window).width()-$('.signbox').width())/2);
	$('.requestbox').css('left',($(window).width()-$('.requestbox').width())/2);
	
	if($.browser.version == '6.0' || $.browser.version == '7.0'){
		$('.footer').css('position','absolute');
		$(window).scroll(
			function(){
				$('.footer').css('top',$(window).scrollTop()+($(window).height()-$('.footer').height()));
			}
		)
	}else{
		$('.footer').css('position','fixed');
	}
	
	//slider
	$.fn.kxbdMarquee = function(options){
		var opts = $.extend({},$.fn.kxbdMarquee.defaults, options);
		
		return this.each(function(){
			var $marquee = $(this);
			var _scrollObj = $marquee.get(0);
			var scrollW = $marquee.width();
			var scrollH = $marquee.height();
			var $element = $marquee.children(); 
			var $kids = $element.children();
			var scrollSize=0;
			var _type = (opts.direction == 'left' || opts.direction == 'right') ? 1:0;
			$element.css(_type?'width':'height',10000);
			if (opts.isEqual) {
				scrollSize = $kids[_type?'outerWidth':'outerHeight']() * $kids.length;
			}else{
				$kids.each(function(){
					scrollSize += $(this)[_type?'outerWidth':'outerHeight']();
				});
			}
			if (scrollSize<(_type?scrollW:scrollH)) return; 
			$element.append($kids.clone()).css(_type?'width':'height',scrollSize*2);
			
			var numMoved = 0;
			function scrollFunc(){
				var _dir = (opts.direction == 'left' || opts.direction == 'right') ? 'scrollLeft':'scrollTop';
				if (opts.loop > 0) {
					numMoved+=opts.scrollAmount;
					if(numMoved>scrollSize*opts.loop){
						_scrollObj[_dir] = 0;
						return clearInterval(moveId);
					} 
				}

				if(opts.direction == 'left' || opts.direction == 'up'){
					var newPos = _scrollObj[_dir] + opts.scrollAmount;
					if(newPos>=scrollSize){
						newPos -= scrollSize;
					}
					_scrollObj[_dir] = newPos;
				}else{
					var newPos = _scrollObj[_dir] - opts.scrollAmount;
					if(newPos<=0){
						newPos += scrollSize;
					}
					_scrollObj[_dir] = newPos;
				}
			}

			var moveId = setInterval(scrollFunc, opts.scrollDelay);

			/*$marquee.hover(
				function(){
					clearInterval(moveId);
				},
				function(){
					clearInterval(moveId);
					moveId = setInterval(scrollFunc, opts.scrollDelay);
				}
			);*/
			
		});
	};
	$.fn.kxbdMarquee.defaults = {
		isEqual:true,
		loop: 0,
		direction: 'left',
		scrollAmount:1,
		scrollDelay:80

	};
	$.fn.kxbdMarquee.setDefaults = function(settings) {
		$.extend( $.fn.kxbdMarquee.defaults, settings );
	};

})
