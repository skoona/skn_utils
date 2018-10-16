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
#
# SknSettings setup:
# class << (SknSetting = SknUtils::Configuration.new( ENV['RACK_ENV'] )); end
#
#

module SknUtils

  class Configuration < NestedResult

    # "filename-only"
    # {config_filename: "filename-only"}
    def initialize(params={})
      super()
      @_last_filelist = []
      @_base_path = './config/'
      @_default_mode = ENV['RACK_ENV'] || 'development'
      cfg_file = params.is_a?(String) ? params : (params[:config_filename] || @_default_mode)
      test_mode = ENV.fetch('TEST_GEM', 'rails').eql?('gem')
      config_path!( test_mode ? './spec/factories/' : './config/' )
      load_config_basename!(cfg_file)
    end

    def config_path!(config_root)
      @_base_path = config_root[-1].eql?('/') ? config_root : "#{config_root}/"
      self
    end

    def load_config_basename!(environment_name=@_default_mode)
      reset_from_empty!(load_config(environment_name), false) # enable dot notation via defined methods(true) vs method_missing(false)
      self
    end

    def load_and_set_settings(ordered_list_of_files)
      reset_from_empty!( load_ordered_list( ordered_list_of_files ), false )
      self
    end
    alias_method :reload_from_files, :load_and_set_settings

    def reload!
      reset_from_empty!( load_ordered_list(@_last_filelist), false )
      self
    end

    # Config.setting_files("/path/to/config_root", "your_project_environment")
    def setting_files(config_root, environment_name) # returns a file array
      config_path!(config_root)
      @_default_mode = environment_name
      configuration_files(environment_name)
    end

    # :reload! required
    def add_source!(file_path_or_hash) # load last
      return {} unless valid_file_path?(file_path_or_hash)
      @_last_filelist.push(file_path_or_hash).flatten
      self
    end

    # :reload! required
    def prepend_source!(file_path_or_hash) # load first
      return {} unless valid_file_path?(file_path_or_hash)
      @_last_filelist.unshift(file_path_or_hash).flatten
      self
    end

    private

    def valid_file_path?(file_path_or_hash)
      if file_path_or_hash.kind_of?(Hash)
        true

      elsif file_path_or_hash.kind_of?(String)
        File.exist?( file_path_or_hash )

      else
        false

      end
    end

    def configuration_files(environment_name=@_default_mode)
      [
          "#{@_base_path}settings.yml",
          "#{@_base_path}settings/#{environment_name}.yml",
          "#{@_base_path}environments/#{environment_name}.yml",
          "#{@_base_path}settings.local.yml",
          "#{@_base_path}settings/#{environment_name}.local.yml",
          "#{@_base_path}environments/#{environment_name}.local.yml"
      ]
    end

    def load_ordered_list(filelist)
      settings_file = nil
      yname = filelist.first

      # maintain last list for :reload
      @_last_filelist = filelist unless @_last_filelist === filelist

      settings_file = yname if !!yname && yname.include?('settings.yml')

      f_base  = {}
      filelist.each do |filepath|
        next unless valid_file_path?( filepath )
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