class ProductsController < Spree::BaseController
  HTTP_REFERER_REGEXP = /^https?:\/\/[^\/]+\/t\/([a-z0-9\-\/]+)$/
  rescue_from ActiveRecord::RecordNotFound, :with => :render_404
  helper :taxons

  respond_to :html

  def index
    if params[:sort_by] == "trending"
      @products = Product.all.sort_by { |n| n.facebook_like_count }.reverse
    else
      @searcher = Spree::Config.searcher_class.new(params)
      @products = @searcher.retrieve_products
    end
    respond_with(@products)
  end

  def show
    @product = Product.find_by_permalink!(params[:id])
    return unless @product

    @variants = Variant.active.includes([:option_values, :images]).where(:product_id => @product.id)
    @product_properties = ProductProperty.includes(:property).where(:product_id => @product.id)
    @selected_variant = @variants.detect { |v| v.available? }

    referer = request.env['HTTP_REFERER']

    if referer && referer.match(HTTP_REFERER_REGEXP)
      @taxon = Taxon.find_by_permalink($1)
    end

    respond_with(@product)
  end

  def fetch_array
    arr = params[:arr].split(",")
    arr.each do |g|
      divider = g.split("-")
      t = Product.find_by_id(divider[1])
      unless t.blank?
        t.update_attribute(:facebook_like_count, divider[0])
      end
    end

    render :text => "Ok"
  end

  def new_sorting
    @product_f_list = []
    unless params[:pro_list].blank?
      lists = params[:pro_list].split("-")
      unless lists.blank?
        lists.each do |list|
          unless list.blank?
            product = Product.find_by_id(list)
            unless product.blank?
              @product_f_list << product
            end
          end
        end
      end
    end
    unless @product_f_list.blank?
      if params[:sort_by] == "recent"
        @products = @product_f_list.sort_by { |n| n.created_at }.reverse
      elsif params[:sort_by] == "popular"
        @orders = Order.all
        @new_product_f_list = []
        unless @orders.blank?
          @orders.each do |order|
            unless order.line_items.blank?
              order.line_items.each do |line_item|
                unless line_item.product.blank?
                  @new_product_f_list << line_item.product
                end
              end
            end
          end
          unless @new_product_f_list.blank?
            new_arr = []
            @new_product_f_list.each do |pp|
              new_arr << pp.id
            end
            b = Hash.new(0)
            new_arr.each do |v|
              b[v] += 1
            end

            @products = []
            b.sort { |a, b| a[1] <=> b[1] }.reverse.each do |k, v|
              unless k.blank?
                p = Product.find_by_id(k)
                unless p.blank?
                  if @product_f_list.include?(p)
                    @products << p
                  end
                end
              end
            end
          end
        else
          @products = []
        end
      elsif params[:sort_by] == "trending"
        @products = @product_f_list.sort_by { |n| n.facebook_like_count }.reverse

      end
    end
    render :partial => "/products/index_new"
  end

  respond_to :html, :js, :json

  respond_override :index => {:js => {:success => lambda { render :partial => "products/index" }}}
#  respond_override :new_sorting => {:js => {:success => lambda { render :partial => "/products/index_new" }}}
  respond_override :show =>{:json=>{:success => lambda { render :json => @product.to_json(
      :include => {
          :taxons=>{:only=>[:id, :name]},
          :images => {:only => [:id, :attachment_file_name]},
          :master => {:only => [:id]},
          :product_groups => {:only => [:id, :name]}}) }}}

  def remove_from_cart
    session_id = session['order_id']
    variant_id = params[:variant_id].to_i

    line_item = LineItem.find(:first, :conditions => "order_id = #{session_id} and variant_id = #{variant_id}")

    if line_item.quantity>1
      line_item.quantity -=1
      line_item.save
    else
      line_item.destroy
    end
    render :nothing => true
  end

  def filter_by_taxon_all
    @product = Product.find_by_permalink(params[:product_link])
    @taxon = @product.taxons[0]
    return unless @taxon

    @searcher = Spree::Config.searcher_class.new(params.merge(:taxon => @taxon.id))
    @products = @searcher.retrieve_products
    render :partial => "/products/index_new"
  end

  def filter_by_taxon
    @taxon = Taxon.find(params[:id])
    return unless @taxon

    @searcher = Spree::Config.searcher_class.new(params.merge(:taxon => @taxon.id))
    @products = @searcher.retrieve_products
    render :js => @products.to_json(:only => [:id, :permalink, :name, :liked],
                                    :methods => :brand,
                                    :include => {
                                        :images => {:only => [:id, :attachment_file_name]},
                                        :master => {:only => [:id]},
                                        :product_groups => {:only => [:id, :name]}
                                    })
  end


  def filter_by_title

    @products = Product.find(:all, :conditions=>['name like ?', "%#{params[:title]}%"])
    render :js => @products.to_json(:only => [:id, :permalink, :name, :liked],
                                    :methods => :brand,
                                    :include => {
                                        :images => {:only => [:id, :attachment_file_name]},
                                        :master => {:only => [:id]},
                                        :product_groups => {:only => [:id, :name]}
                                    })
  end

  def ship_list
#    ids = Array.new
#    current_order.line_items.each do |item|
#      ids[item.id]=item.varient.id
#    end
    email=Shiplist.shiplist_email(params[:recipient], params[:message], current_order.id, request.protocol, request.host_with_port)
    email.deliver
    render :text => "ok"
  end

  def load_ship_list
    session[:order_id] = params[:id]
#     current_order = Order.find(1069267045);
    redirect_to cart_path
  end


  private

  def accurate_title
    @product ? @product.name : super
  end

end
