;(function($){
        $.fn.rankingtab = function(options) {

			var opts = $.extend({}, $.fn.rankingtab.defaults, options);

			return this.each(function() {
				var $rklist = $(this);
				$('ul.rktab li a', $rklist).bind('click', function() {
					onclick.call(this, $rklist, opts);
					return false;
				}).filter(':first').click();
			});
		}; 

		function onclick($rklist, opts) {
			$('li.selected', $rklist).removeClass('selected');
			var $a = $(this).parent().addClass('selected');
			get_data($(this).text(), $rklist, opts);
		}

		function get_data(tag, $rklist, opts) {
			var url = opts.baseurl+tag+'.json';
			$.getJSON(url, function(a) {
				show_data(a, $rklist, opts);
			});
		}

		function show_data(a, $rklist, opts) {
			var list = '<ul class="rk_list">';
			var c = 1, 
			for (i=0; i<a.length; i++) {
				var url = a[i][0];
				var title = a[i][1];
					title = title.substr(0,opts.trunc);
					title += '...';
				list += '<li class="rk_item"><span class="rk_order">'+c+' : </span>'+'<a href="'+url+'">'+title+'</a></li>';
				c++;
			}

			list += '</ul>';
			$("div.accessranking").empty().html(list);
		}

        $.fn.rankingtab.defaults = {
			trunc: 60
        };

})(jQuery);
