;(function($){
     $.fn.rankingtab = function(options) {

      var $options = $.extend({}, $.fn.rankingtab.defaults, options);

      return this.each(function() {
        var $elem = $(this)
        , $children = $elem.find('li a');
        
        $children.on('click', function() {
          onclick.call(this, $elem, $options);
            return false;
        }).filter(':first').click();

      });
    }; 

    function onclick($elem, $options ) {
      $elem.find('li').removeClass('active');
      var tag = $(this).attr('href').replace('#', '');
      $(this).parent().addClass('active');
      get_data(tag, $elem, $options);
    }

    function get_data(tag, $elem, $options) {
      var url = $options.url+tag+'.json';
      $.getJSON(url, function(data) {
            show_data(data, $elem, $options);
      });
    }

    function show_data(data, $elem, $options) {
      var list = '<ul class="entries">'
      , a = data.rows
      , c = 1;
      for (i=0; i<a.length; i++) {
        var url = a[i][0]
        , title = a[i][1];
        title = title.substr(0, $options.trunc);
        title += '...';
        list += '<li class="entry-item"><span class="ranking-count">';
        list += c + ': </span><a href="';
        list += url + '">';
        list += title + '</a></li>';
        c++;
      }
      list += '</ul>';
      $('.accessranking-content', $elem).empty().html(list);
    }

    $.fn.rankingtab.defaults = {
          trunc: 60
    };

})(jQuery);
