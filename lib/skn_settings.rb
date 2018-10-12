##
# Initialize:
#   SknSettings.load_config_basename!('some_name')
#
# Usage:
#   SknSettings.<config.key>[.<config.key>]...
##

# This creates a global constant (and singleton) with a defaulted configuration
class << (SknSettings = SknUtils::Configuration.new())
end