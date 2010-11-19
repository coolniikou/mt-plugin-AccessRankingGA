//JSONAccessRanking Plugin jQuery rankingtab plugin

(function($){

        $.fn.extend({ 
                rankingtab : function(options) {
                        var defaults = {
                			trunc: 40
        				};
                        var options = $.extend(defaults, options);
                        
                        return this.each(function() {
                                var $rklist = $(this);
                                $('ul.rktab li a', $rklist).bind('click', function() {
                                        onclick.call(this, $rklist);
                                        return false;
                                }).filter(':first').click();
                        });

                        function onclick($rklist){
                                $('li.selected', $rklist).removeClass('selected');
                                var $a = $(this).parent().addClass('selected');
                                get_data($(this).text(), $rklist);
                        };

                        function get_data(tag, $rklist) {
                                var url = options.baseurl+tag+'.json';
                                $.getJSON(url, function(a){
                                        show_data(a, $rklist);
                                });
                        };

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
                        };
                }
        });

})(jQuery);

/*--
HTML

<div class="widget-archives widget">
    <h3 class="widget-header">人気アクセスランキング</h3>
	<div class="ranking">
        <ul class="rktab">
        	<li><a href="#week"><em>week</em></a></li>
            <li><a href="#month"><em>month</em></a></ll>
        </ul>
    	<div class="widget-content accessranking">
    	</div>
	</div>
</div>


footerJS

<script type="text/javascript" src="<$mt:BlogURL$>js/rankingtab.js"></script>
<script type="text/javascript">
$(function(){
	$('div.ranking').rankingtab({
        baseurl:   'json_url_',
        trunc: 40
	});
});
</script>


sample_css

ul.rktab {
    list-style: none;
    margin: 10px 0 auto;
    padding: 0;
	zoom: 1; }
ul.rktab:after { 
	content: ".";
	display: block;
	height: 0;
	clear: both;
	visibility: hidden; }
ul.rktab li {
    float: left;
    margin: 0;
	padding: 0;
	height: 26px;
	background: transparent;
	border: 1pt solid #99CCFF;
	border-bottom: none; }
ul.rktab li.selected,
ul.rktab li:hover {
    float: left;
    margin: 0;
	padding: 0;
	height: 26px;
	background: #ADD8E6; }
ul.rktab li a {
    z-index: 12;
	margin: 0;
    padding: 0 0 0 10px;
    color: #27537a;
    font-size: 12px;
    font-weight: bold;
    line-height: 2.4em;
    text-align: center;
    text-decoration: none;
    white-space: nowrap;
	float: left;
	display: block;
	background: transparent;    }
ul.rktab li.selected a,
ul.rktab li a:hover {
    z-index: 12;
	margin: 0;
    padding: 0 0 0 10px;
    color: #000;
    font-size: 12px;
    line-height: 2.4em;
    text-align: center;
    text-decoration: none;
    white-space: nowrap; 
	float: left;
	display: block;
	background: #ADD8E6;    }
ul.rktab li a em{
    z-index: 12;
	margin: 0;
    padding: 0 10px 0 0;
	font-style: normal;
    font-weight: bold;
    text-align: center;
    white-space: nowrap; 
	float: left;
	display: block;
	background: transparent;    }
ul.rktab li.selected a em,
ul.rktab li a:hover em{
    z-index: 12;
	margin: 0;
    padding: 0 10px 0 0;
    text-align: center;
    text-decoration: none;
    white-space: nowrap;
	float: left;
	display: block;
	background: ##ADD8E6;    }
ul.rktab li.selected a,
ul.rktab li.selected a:hover {
	color: #000; }
div.accessranking {
	margin: 0;
	padding: 10px;
	border: 1pt solid #99CCFF; }

--*/
