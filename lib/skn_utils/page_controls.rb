##
# <Rails.root>/lib/skn_utils/page_controls.rb
#
# *** See SknUtils::NestedResultBase for details ***
#
##
# (Defaults)
# :enable_serialization = true     -- for function
# :depth = :multi_with_arrays
##

module SknUtils

  class PageControls < NestedResultBase
    #:nodoc:
    def initialize(params={})
      super( params.merge({enable_serialization: true, depth: :multi_with_arrays}) )
    end
  end
  
end
