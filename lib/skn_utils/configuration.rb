# ##
# lib/skn_utils/configuration.rb
#
# @see SknSettings
#
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
# -------------------------------------------------

module SknUtils

  class Configuration < NestedResult

    # "filename-only"
    # {config_filename: "filename-only"}
    def initialize(params={})
      @default_mode = ENV.fetch('RACK_ENV', 'development')
      @config_filename = params.is_a?(String) ? params : params.fetch(:config_filename, @default_mode)
      test_mode = ENV.fetch('TEST_GEM', 'rails').eql?('gem')
      config_path!( test_mode ? './spec/factories' : './config' )
      load_config_basename!(@config_filename)
    end

    def load_config_basename!(conf=@default_mode)
      reset_from_empty!(load_config(conf), false) # enable dot notation via defined methods(true) vs method_missing(false)
      self
    end

    def reload!
      reset_from_empty!( load_ordered_list(@_last_filelist) )
      self
    end

    def config_path!(fpath)
      if File.exist?("#{fpath}settings.yml")
        @base_path = fpath
      elsif File.exist?("#{fpath}/settings.yml")
        @base_path = "#{fpath}/"
      end
    end

    def load_and_set_settings(ordered_list_of_files)
      reset_from_empty!( load_ordered_list( ordered_list_of_files ) )
      self
    end
    alias_method :reload_from_files, :load_and_set_settings

    # Config.setting_files("/path/to/config_root", "your_project_environment")
    def setting_files(config_root, env_name) # returns a file array
      config_path!(config_root)
      @default_mode = env_name
      configuration_files()
    end

    def add_source!(file_path_or_hash) # load last
      return {} unless file_path_or_hash.is_a?(Hash) || File.exist?( file_path_or_hash )
      load_and_set_settings( (configuration_files() + [file_path_or_hash]).flatten )
    end

    def prepend_source!(prepend_fpath) # load first
      return {} unless prepend_fpath.is_a?(Hash) || File.exist?( prepend_fpath )
      load_and_set_settings( ([prepend_path] + configuration_files()).flatten )
    end

    private

    def configuration_files(default=@default_mode)
      [
          "#{@base_path}settings.yml",
          "#{@base_path}settings/#{default}.yml",
          "#{@base_path}environments/#{default}.yml",
          "#{@base_path}settings.local.yml",
          "#{@base_path}settings/#{default}.local.yml",
          "#{@base_path}environments/#{default}.local.yml"
      ]
    end

    def load_ordered_list(filelist)
      settings_file = nil
      yname = filelist.first
        return {} unless  yname.is_a?(Hash) || (yname && File.exist?( yname ))

      # maintain last list for :reload
      @_last_filelist = filelist

      settings_file = yname if yname.include?('settings.yml')

      f_base  = {}
      filelist.each do |filepath|
        next unless filepath.is_a?(Hash) || File.exist?(filepath)
        settings_file = filepath if filepath.include?('settings.yml')
        f_env   = filepath.is_a?(Hash) ? filepath : load_yml_with_erb(filepath)
        f_base  = f_base.deep_merge!(f_env) unless (f_env.nil? || f_env.empty?)
      end

      unless settings_file.nil?
        config_path!( File.dirname(settings_file) ) # maintain root dir
      end

      f_base
    end

    def load_config(conf)
      load_ordered_list( configuration_files(conf) )
    end

    def load_yml_with_erb(yml_file)
      erb = ERB.new(File.read(yml_file)).result
      erb.empty? ? {} : Psych.load(erb)
    rescue => e
      puts "#{self.class.name}##{__method__} Class: #{e.class}, Message: #{e.message}"
      {}
    end
  end

end