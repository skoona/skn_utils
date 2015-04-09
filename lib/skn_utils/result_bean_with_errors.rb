##
# <Rails.root>/lib/skn_utils/result_bean_with_errors.rb
#
# *** See SknUtils::NestedResultBase for details ***
#
##
# (Defaults)
# :enable_serialization = false     -- for speed
# :depth = :multi
##
#  Add the ActiveModel::Errors Object to bean structure, and
#  filters @errors out of serialization features; i.e. not included in *.attributes()
#
#  bean.errors.add(:name, "can not be nil") if name == nil
###

module SknUtils
  
  class ResultBeanWithErrors < NestedResultBase
    include ActiveModel::Conversion
    extend ActiveModel::Naming

    attr_reader :errors

    #:nodoc:
    def initialize(params={})
      @errors = params.delete :errors
      @errors = ActiveModel::Errors.new(self) unless @errors.present?
      super(params)
    end
    
    #:nodoc:
    def read_attribute_for_validation(attr)
      send(attr)
    end

    #:nodoc:
    def self.human_attribute_name(attr, options = {})
      attr
    end

    #:nodoc:
    def self.lookup_ancestors
      [self]
    end
  end
end
