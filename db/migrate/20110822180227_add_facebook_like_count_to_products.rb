class AddFacebookLikeCountToProducts < ActiveRecord::Migration
  def self.up
    add_column :products, :facebook_like_count, :integer, :null => false, :default => 0
  end

  def self.down
    remove_column :products, :facebook_like_count
  end
end
