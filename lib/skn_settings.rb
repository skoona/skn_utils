# frozen_string_literal: true

##
# Initialize:
#   SknSettings.load_config_basename!('some_name')
#
# Usage:
#   SknSettings.<config.key>[.<config.key>]...
##
# Filepath Targets:
# -------------------------------------------------
# <prepend-somefile>
# config/settings.yml
# config/settings/#{environment}.yml
# config/environments/#{environment}.yml
#
# config/settings.local.yml
# config/settings/#{environment}.local.yml
# config/environments/#{environment}.local.yml
# <append-somefile>
#
#
# Public API
# -------------------------------------------------
# load_config_basename!(environment_name)
# config_path!(config_root)
# load_and_set_settings(ordered_list_of_files)
#   - Alias: reload_from_files(ordered_list_of_files)
# reload!()
# setting_files(config_root, environment_name)
# add_source!(file_path_or_hash)
# prepend_source!(file_path_or_hash)
# -------------------------------------------------
# ##
# This creates a global constant (and singleton) with a defaulted configuration
class << (SknSettings = SknUtils::Configuration.new())
end