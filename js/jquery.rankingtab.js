;(function($){
        $.fn.rankingtab = function(options) {

			var opts = $.extent({}, $.fn.rankingtab.defaults, options);

			return this.each(function() {
				var $rklist = $(this);
                $('ul.rktab li a', $rklist).bind('click', function() {
					onclick.call(this, $rklist);
                    return false;
				}).filter(':first').click();
			});
		}; 

		function onclick($rklist) {
			$('li.selected', $rklist).removeClass('selected');
			var $a = $(this).parent().addClass('selected');
			get_data($(this).text(), $rklist);
		}

		function get_data(tag, $rklist) {
			var url = options.baseurl+tag+'.json';
			$.getJSON(url, function(a) {
				show_data(a, $rklist);
			});
		}

		function show_data(a, $rklist) {
			var list = '<ul class="rk_list">';
			var c = 1;
			for (i=0; i<a.length; i++) {
				var title = a[i]['dxp:dimension']['ga:pageTitle'].value;
					title = title.substr(0,options.trunc);
					title += '...';
				var url = a[i]['dxp:dimension']['ga:pagePath'].value;
				list += '<li class="rk_item">'+c+' : '+'<a href="'+url+'">'+title+'</a></li>';
				c++;
			}

			list += '</ul>';
			$("div.accessranking").empty().html(list);
		}

        $.fn.rankingtab.defaults = {
			trunc: 40
        };

})(jQuery);
