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
      @base_path = config_path!( test_mode ? './spec/factories' : './config' )
      load_config_basename!(@config_filename)
    end

    def load_config_basename!(conf=@default_mode)
      reset_from_empty!(load_config(conf), false) # enable dot notation via defined methods(true) vs method_missing(false)
      self
    end
    alias_method :reload!, :load_config_basename!

    def config_path!(fpath)
      @base_path = fpath if File.exist?("#{fpath}settings.yml")
      @base_path = "#{fpath}/" if File.exist?("#{fpath}/settings.yml")
    end

    def load_and_set_settings(ordered_list_of_files)
      reset_from_empty!( load_ordered_list( ordered_list_of_files ) )
    end
    alias_method :reload_from_files, :load_and_set_settings

    # Config.setting_files("/path/to/config_root", "your_project_environment")
    def setting_files(config_root, env_name) # returns a file array
      config_path!(config_root)
      @default_mode = env_name
      configuration_files()
    end


    def add_source!(file_path_or_hash) # load last
      return {} if File.exist.eql?( file_path_or_hash )
      ordered_list_of_files = configuration_files().push( file_path_or_hash )  # or unshift
      load_and_set_settings(ordered_list_of_files)

      # Settings.add_source!({some_secret: ENV['some_secret']})
    end

    def prepend_source!(prepend_fpath) # load first
      return {} if File.exist.eql?( prepend_fpath )
      ordered_list_of_files = configuration_files().unshift(prepend_path)  # or unshift
      load_and_set_settings(ordered_list_of_files)
    end

    private

    def configuration_files(default=@default_mode)
      @_last_filelist = [
          "#{@base_path}settings.yml",
          "#{@base_path}settings/#{default}.yml",
          "#{@base_path}environments/#{default}.yml",
          "#{@base_path}settings.local.yml",
          "#{@base_path}settings/#{default}.local.yml",
          "#{@base_path}environments/#{default}.local.yml"
      ]
    end

    def load_ordered_list(filelist)
      yname = filelist.shift
        return {} unless File.exist?( yname )
        f_base  = load_yml_with_erb(yname)

      filelist.each do |filepath|
        next unless File.exist?(filepath)
        f_env   = load_yml_with_erb(filepath)
        f_base  = f_base.deep_merge!(f_env) unless (f_env.nil? || f_env.empty?)
      end

      f_base
    end

    def load_config(conf)
      yname   = "#{@base_path}settings.yml"
        return {} unless File.exist?(yname)
        f_base  = load_yml_with_erb(yname)

     do_this = [
         "#{@base_path}settings.yml",
         "#{@base_path}settings/#{conf}.yml",
         "#{@base_path}settings/environments/#{conf}.yml",
         "#{@base_path}settings.local.yml",
         "#{@base_path}settings/#{conf}.local.yml",
         "#{@base_path}settings/environments/#{conf}.local.yml"
     ]

      load_ordered_list( do_this )
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