##
# <Rails.root>/lib/skn_util/generic_bean.rb
#
# *** See SknUtil::NestedResultBase for details ***
#
##
# (Defaults)
# :enable_serialization = true
# :depth = :multi

module SknUtil

  class GenericBean < NestedResultBase
    def initialize(params={})
      super( params.merge({enable_serialization: true}) )
    end
  end # end class
  
end # end module
