require 'rubygems'
require 'open-uri'

namespace :db do
  desc "Load the sample data from db/sample.rb"

  task :fix_recent => :environment do
    @products = Product.all
    unless @products.blank?
      @products.each_with_index do |product, i|
        old_time = product.created_at
        product.update_attribute(:created_at, old_time.to_time + i.hour)
      end
    end
  end
end

