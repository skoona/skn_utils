# ##
# File: ./lib/skn_utils/generators/install_generators.thor
#

require 'thor'
require 'thor/group'

module SknUtils
  module Generators

    class Installer < Thor::Group
      include Thor::Actions

      # Define arguments and options
      argument :dir_name, :default => 'config'

      desc "Install settings." #, "Creates the default application settings files for the basic environments."

      def self.source_root
        File.expand_path('templates', __dir__)
        Dir.pwd
      end

      def copy_app_settings_directory
        directory 'templates/configs', "#{dir_name}/", :verbose => true
      end

    end
  end
end
