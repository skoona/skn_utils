##
# <Rails.root>/lib/skn_utils/generic_bean.rb
#
# *** See SknUtils::NestedResultBase for details ***
#
##
# (Defaults)
# :enable_serialization = true
# :depth = :multi

module SknUtils

  class GenericBean < NestedResultBase
    #:nodoc:
    def initialize(params={})
      super( params.merge({enable_serialization: true}) )
    end
  end # end class
  
end # end module
