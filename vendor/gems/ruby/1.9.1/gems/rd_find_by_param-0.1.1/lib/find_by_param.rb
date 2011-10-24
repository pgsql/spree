begin
  require "active_support/multibyte"
rescue LoadError
  require "rubygems"
  require "active_support/multibyte"
end

module Railslove
  module Plugins
    module FindByParam

      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods

        def make_permalink(options={})
          options[:field] ||= "permalink"

          self.send(:validates_uniqueness_of, options[:field])

          if self.column_names.include?(options[:field].to_s)
            options[:param] = options[:field]
            before_validation(:on => :create){ save_permalink }
          end

          self.permalink_options = options
          extend Railslove::Plugins::FindByParam::SingletonMethods
          include Railslove::Plugins::FindByParam::InstanceMethods
        rescue
          # Database is not available (not a problem if we're running rake db:create or rake db:bootstrap)
        end
      end

      module SingletonMethods

        def find_by_param(value,args={})
          if permalink_options[:prepend_id]
            param = "id"
            value = value.to_i
          else
            param = permalink_options[:field]
          end
          self.send("find_by_#{param}".to_sym, value, args)
        end

        def find_by_param!(value, args={})
          param = permalink_options[:field]
          obj = find_by_param(value, args)
          raise ::ActiveRecord::RecordNotFound unless obj
          obj
        end
      end

      module InstanceMethods

        protected
        def save_permalink
          return unless self.class.column_names.include?(permalink_options[:field].to_s)
          return if !changed?

          base_value = to_param
          permalink_value = base_value
          counter = 0

          begin
            permalink_value = base_value + ((counter == 0) ? "" : "-#{counter}")
            query = self.class.send("where", "#{permalink_options[:field]} = ?", permalink_value)
            counter += 1
          end while query.limit(1).present?

          write_attribute(permalink_options[:field], permalink_value)
          true

        end
      end

    end
  end
end

class ActiveRecord::Base
  class_attribute :permalink_options
  self.permalink_options = {:param => :id}

  #default finders these are overwritten if you use make_permalink in your model
  def self.find_by_param(value,args={})
    find_by_id(value,args)
  end
  def self.find_by_param!(value,args={})
    find(value,args)
  end

end
ActiveRecord::Base.send(:include, Railslove::Plugins::FindByParam)

