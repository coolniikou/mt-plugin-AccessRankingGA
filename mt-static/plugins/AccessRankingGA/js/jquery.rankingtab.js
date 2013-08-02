;(function($){

    var RankingTab = function(elem, options) {
          this.elem = elem;
          this.$elem = $(elem);
          this.options = options;
          this.children = this.$elem.children().find('li');
          that = this
    };

    RankingTab.prototype = {
        defaults: {
            trunc: 40
        },

        init: function() {
            this.config = $.extend({}, this.defaults, this.options);
            this.children.each(function(){
                $(this).on("click", $.proxy( that.onClick, $(this) ));
            });
            this.children.click();
            return this;
        },

        onClick: function() {
            parent = this.parent().parent();
            if(this.hasClass('active')) return; 
            $(':not(this)').removeClass('active');
            this.addClass('active');
            that.getData(this.text(), parent);
        },

        getData: function(text, parent) {
            var uri = this.config.url + text + '.json';
            $.getJSON(uri, function(data) {
                      that.showData(data, parent);
            });
        },

        showData: function(data, parent) {
            var list = '<ol class="ranking-list">'
            , json = data.rows;
            for (var i = 0; i < json.length; i++) {
                var url = json[i][0]
                , title = json[i][1];
                title = title.substr(0, this.config.trunc);
                title += "....";
                list += '<li><a href="'+ url + '">';
                list += title + '</a></li>';
            }
            list += '</ol>';
            $('.ranking-content', parent).empty().html(list);
        }
    }

    RankingTab.defaults = RankingTab.prototype.defaults;
    $.fn.rankingtab = function(options) {
        return this.each( function() {
            new RankingTab(this, options).init();
            $(this).find('li').filter(':first').click();
        });
    };

})(jQuery);
