##
# <project.root>/lib/skn_utils/generic_bean.rb
#
# *** See SknUtils::NestedResultBase for details ***
#
##
# (Defaults)
# :enable_serialization = true
# :depth = :single

module SknUtils

  class ValueBean < NestedResultBase
    #:nodoc:
    def initialize(params={})
      super( params.merge({enable_serialization: true, depth: :single}) )
    end
  end # end class
  
end # end module
