var Spree = {
    collections : {
        products: {},
        categories:{}
    },
    models      : {},
    p_container: null
};

Spree.dimmer = {

    init: function() {
        this.el = $('#dim');
        this.el.click(this.undim);
    },

    dim : function() {
        this.el.fadeTo(300, .72);
        this.active = true;
    },

    undim : function() {
        $('#dim').fadeTo(300, 0, function() {
            $(this).hide()
        });
        this.active = false;
        if (Spree.left_nav.active) {
            Spree.left_nav.close();
        }
        $('#product_popup').remove();

    }
};

Spree.loader = {
    init: function() {
        this.el = $('<div class="ajax_loader"></div>');
        this.el.appendTo("body");
    },
    show:function() {
        this.el.show();
    },
    hide:function() {
        this.el.hide();
    }
};

Spree.notice = {
    init: function() {
        this.el = $('#footer .notice').hide();
    },

    message: function(message) {
        this.el.html(message).fadeIn(300).delay(500).fadeOut(300); //500, 5000, 500
    }
};

Spree.left_nav = {
    active     : false,
    sub_active : false,
    el_sub: false,

    load_categories: function(categories) {
        Spree.collections.categories = categories;
    },

    init: function() {
        // Add dynamic category menu from pre-populated category collection


        $("body").append(JST.category_menu(
        {
            categories: Spree.collections.categories
        }
                ));

        // Cache jQueries
        Spree.left_nav.el_button = $('#nav-ini');
        Spree.left_nav.el_nav = $('#nav');
        Spree.left_nav.el_sub = $('#subnav');

        // Set localized (proxied) event callbacks
        Spree.left_nav.el_button.hover(this.open);

        Spree.left_nav.el_nav.find('a').hover(this.open_sub_menu);
        Spree.left_nav.el_sub.find('a').hover(this.on_item_click);
        Spree.left_nav.el_nav.find('a').click(this.on_item_click);
    },

    open: function(event) {

        // Hide button and show menu
        Spree.left_nav.el_nav.animate({
            'marginLeft':'0px'
        }, 350, 'easeOutQuad');
        Spree.left_nav.el_button.animate({
            'marginLeft':'-200px'
        }, 350, 'easeInQuad');

        Spree.left_nav.active = true;
        Spree.dimmer.dim();
    },

    close: function() {


        Spree.left_nav.el_button.delay(300).animate({
            'marginLeft':'0'
        }, 350, 'easeOutQuad');
        Spree.left_nav.el_nav.animate({
            'marginLeft':'-200px'
        }, 300, 'easeInQuad');

        if (Spree.left_nav.sub_active) {
            Spree.left_nav.el_sub.delay(200).animate({
                'marginLeft':'-400px'
            }, 300, 'easeInQuad');
            Spree.left_nav.sub_active = false;
        } else {
            Spree.left_nav.el_sub.animate({
                'marginLeft':'-400px'
            }, 300, 'easeInQuad');
        }

        Spree.left_nav.el_nav.children('.selected').removeClass('selected');
        Spree.left_nav.active = false;

        Spree.dimmer.undim();
    },

    open_sub_menu: function(event) {

        event.preventDefault();

        Spree.left_nav.subnav_active = true;
        if (Spree.left_nav.el_sub) Spree.left_nav.el_sub.remove();


        // Fetch category children and populate new sub-nav
        var sub_cat = _.select(Spree.collections.categories, function(cat) {
            if ($(event.currentTarget).attr('href') == cat.id) {
                //alert(cat.id);
                return cat;
            }
        });
        parent_cat = sub_cat[0]
        sub_cat = sub_cat[0].children;

        Spree.left_nav.el_sub = $(
                JST.sub_category_menu({
                    sub_categories: sub_cat,
                    cat_id:parent_cat.id,
                    cat_name:parent_cat.name
                })
                ).appendTo($('body'));


        // Animate the slideout
        Spree.left_nav.el_sub.find('#subnav').animate(
        {
            'marginLeft':'0px'
        }, 300, 'easeOutQuad'
                ).addClass('selected');

        // Add the click events
        Spree.left_nav.el_sub.find('li a').click(Spree.left_nav.on_item_click);
    },

    on_item_click: function(event) {
        event.preventDefault();
        //alert("test");

        $.getJSON('products/filter_by_taxon', {
            "id":$(this).attr("href")
        }, function(data) {
            //console.log(data);
            Spree.show_products(data);
            //Spree.left_nav.el_sub.close();
            Spree.left_nav.close();
        });


        //this.el_sub.find('li a').click($.proxy(this, 'on_item_click'));

    },

    on_item_brand_click: function() {
        event.preventDefault();

        SR.collections.products.filter_by_brand(
                $(event.currentTarget).attr('href')
                );
        SR.ux.item_container.loading_on();

        this.close();
    }

};

Spree.ship_list = {

    show: function() {
        // alert('test');
        Spree.ship_list.el = $(JST.shiplist_send());
        $("body").append(Spree.ship_list.el);
        //jQuery("<div>Baran Khan</div>").appendTo($("body"));


        Spree.ship_list.el.find('a.close').click(this.hide);

        var _el = Spree.ship_list.el.find('#recipient');
        var _mes = Spree.ship_list.el.find('#shiplist_message');
        this.el.find('a.send-now').bind('click', function() {
            $.ajax({
                type: 'GET',
                url: "/products/ship_list",
                context: document.body,
                data: {
                    recipient: _el.val(),
                    message: _mes.val()
                },
                beforeSend: function(xhr) {
                    $("#fb-like-loader").fadeIn();
                },
                success: function(data, xhr) {
                    alert("email sent to recepiant.");
                    Spree.ship_list.hide();
                }
            });
        });


        Spree.ship_list.el.fadeIn(300); //500

        Spree.dimmer.dim();


    },
    hide: function(event) {
        if (event) event.preventDefault();
        $('#shiplist-send-container').remove();
        Spree.dimmer.undim();

    }


};
Spree.search_box = {

    phrase: 'Enter your favorite brand ...',
    el: false,
    init: function() {
        Spree.search_box.el = $("#search");
        $('#search').click(this.on_click);
        $('#search').blur(this.on_blur);
        $("#search").bind("keypress", function(event) {
            if (event.keyCode == 13) {

                $.getJSON('products/filter_by_title', {
                    "title":Spree.search_box.el.val()
                }, function(data) {
                    //console.log(data);
                    Spree.show_products(data);
                    //Spree.left_nav.el_sub.close();

                });
            }
        });
    },

    on_click: function() {

        if (Spree.search_box.el.val() == Spree.search_box.phrase) {
            $('#search').val('');
            //alert('test');
        }
    },

    on_blur: function() {

        if (Spree.search_box.el.val() == '') Spree.search_box.el.val(Spree.search_box.phrase);
    }
};


$(document).ready(function() {

    $('#shiplist-send').click(function() {
        Spree.ship_list.show();
    });

});