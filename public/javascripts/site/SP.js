Spree.init = function() {
    //console.log("Spree initialized...");
    Spree.p_container = $('#item-container');
    Spree.show_footer_cart();
    Spree.dimmer.init();
    Spree.loader.init();
    Spree.cart.init();
    Spree.notice.init();
    Spree.search_box.init();

    //Spree.left_nav.init();
    Cufon.replace('.button1, #footer .f-buttons li a', {
        textShadow:'1px 1px #0e4624'
    });
};

Spree.show_products = function(products) {
    this.collections.products = products;
    if (this.p_container == null) {
        this.p_container = $('#item-container');
    }
    var html = '';
    if (!Spree.collections.products.length) {
        html = "<h3>Sorry, we couldn't find anything in this category.</h3>";
    }
    var new_products_string = "";
    _.each(this.collections.products, function(pr) {
        html += JST.product_icon({
            product : pr
        });
        new_products_string = new_products_string + pr.id + "-";
    });
    $("#page-options").html('<ul> <li><a href="javascript:" onclick=get_sort_type("recent")>Most Recent</a></li> <li><a href="javascript:" onclick=get_sort_type("popular")>Popular</a></li> <li><a href="javascript:" onclick=get_sort_type("trending")>Trending</a></li> </ul>');
    $("#page-options").append('<input type="hidden" id="pro_lists" />');
    $("#pro_lists").val(new_products_string);
    this.p_container.html(html);
    this.p_container.find('.item').bind('mouseenter', this.show_product_highlight);
    this.p_container.find('.item').bind('mouseleave', this.remove_product_highlight);
    this.p_container.find('.view-sticker-details_new').bind('click', this.show_product_box);
    this.p_container.find('.item .add-to-cart').bind('click', this.cart.add);


    this.p_container.find('.item.hide').each(function(i, item) {
        $(item).delay(5).show(// i*75
                'scale', {
            easing:'easeOutBounce'
        }, 10);      //800
    });
};

Spree.show_product_box = function(event) {
    event.stopImmediatePropagation();
    event.preventDefault();
    var product_id = $(event.currentTarget).closest('.product_icon').attr('data-product-permalink');
    var popup = null;
    Spree.loader.show();

    $.getJSON('/products/' + product_id, function(data) {
        Spree.loader.hide();
        Spree.dimmer.dim();
        if ($("#product_popup").length > 0)
            $("#prodcut_popup").remove();
        popup = $(JST.product_popup({
            product: data
        })).appendTo("body");
        $(".right").append('<a href="javascript:;" id="iframe_div"><iframe src="http://www.facebook.com/plugins/like.php?app_id=166078963469410&amp;href=http%3A%2F%2Fli117-69.members.linode.com:3000%2Fproducts%2F' + product_id + '&amp;send=false&amp;layout=button_count&amp;width=80&amp;show_faces=true&amp;action=like&amp;colorscheme=light&amp;font&amp;height=21" scrolling="no" frameborder="0" style="border:none; overflow:hidden; width:80px; height:21px;" allowTransparency="true"></iframe></a>');

        popup.find('a.close').click(function(event) {
            if (event) event.preventDefault();

            Spree.dimmer.undim();
        });
        popup.find('a.add-now').click(Spree.cart.add);
        popup.find('a.brand').click(Spree.left_nav.on_item_click);
    });
};

Spree.show_product_highlight = function(event) {
    $(event.currentTarget).find('.data-container').fadeIn(10);//200
};

Spree.remove_product_highlight = function(event) {
    $(event.currentTarget).find('.data-container').fadeOut(10);//200
};

Spree.show_footer_cart = function() {
    var el = $('#footer-bg');
    $('#footer .flash.notice').hide();
    el.delay(10).animate({ //500
        'marginBottom':'0px'
    }, 10); //1000
    el.find('.cart_icon').live('click', Spree.cart.remove);
};

Spree.cart = {
    init: function() {
        this.el = $('#footer-bg');
        this.el.delay(10).animate({ //500
            'marginBottom':'0px'
        }, 10); //1000
//        this.el.find('.cart_icon').click(
//                $.proxy(this, 'remove_item')
//                ).hide().fadeIn(10); //1500

    },
    add: function(event) {
        event.preventDefault();
        event.stopImmediatePropagation();
        this.el = Spree.cart.el;
        var product_id = null;
        if (typeof($(this).attr("data-product-id")) !== 'undefined') {
            product_id = $(this).attr('data-product-id');
        } else {
            product_id = $(event.currentTarget).closest('.product_icon').attr('data-product-id');
        }
        var product = _.find(Spree.collections.products, function(p) {
            if (p.id == product_id) {
                return p;
            }
        });
        //console.log(product);
        if (this.el.find('.cart_icon').length < 9) {
            //Spree.dimmer.dim();
            $.post('/orders/populate?variants[' + product.master.id + ']=1', function() {
                this.el = Spree.cart.el;
                this.el.find('.empty-cart').hide();
                this.el.find('.cart').show().prepend(
                        JST.cart_icon({
                            product: product
                        })
                        );
                this.el.find('.cart_icon').first().click(
                        Spree.cart.remove
                        ).hide().fadeIn(10); //1500
                //  Spree.dimmer.undim();
                Spree.notice.message('Added ' + product.name + ' to your cart.');
            });

        }
        else {
            alert("Sorry, only 9 items are allowed in your cart. Complete this order by checking out, and come back for more!");
        }

    },
    remove: function(event) {
        event.preventDefault();
        event.stopImmediatePropagation();
        if (!event.currentTarget.title == "") {
            $.ajax({
                url: "/products/remove_from_cart?variant_id=" + event.currentTarget.title,
                beforeSend: function(xhr) {
                    $("#footer-loader").fadeIn();
                },
                success: function() {
                    $(event.currentTarget).remove();
                    $("#footer-loader").fadeOut();
                },
                error: function(xhr) {
                    $(event.currentTarget).remove();
                    $("#footer-loader").fadeOut();

                }

            });
        }
        else {
            $(event.currentTarget).remove();
        }
    }
};

$(document).ready(function() {
    Spree.init();

});
function get_sort_type(sort_type) {
    var pro_lists = $("#pro_lists").val();
    $.ajax({
        url: '/products/new_sorting?pro_list=' + pro_lists + '&sort_by=' + sort_type, type: 'get', dataType: 'html',
        processData: false,
        success: function(data) {
//            Spree.show_products(data);
            $("#item-container").html(data);

        }
    });
}