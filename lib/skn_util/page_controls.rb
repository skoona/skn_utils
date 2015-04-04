##
# <Rails.root>/lib/skn_util/page_controls.rb
#
# *** See SknUtil::NestedResultBase for details ***
#
##
# (Defaults)
# :enable_serialization = true     -- for function
# :depth = :multi_with_arrays
##

module SknUtil

  class PageControls < NestedResultBase
    def initialize(params={})
      super( params.merge({enable_serialization: true, depth: :multi_with_arrays}) )
    end
  end
  
end
