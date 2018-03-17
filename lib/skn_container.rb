##
# Register:
#   SknContainer.<new.key> = AnyObject
#
# Resolve:
#   SknContainer.<new.key>  # => AnyObject
#   SknContainer.<new.key>?  # => True | False based on existance #
##

# This creates a global constant (and singleton) wrapping a Hash
class << (SknContainer = SknUtils::NestedResult.new())
end