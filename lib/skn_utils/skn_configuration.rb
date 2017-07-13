#
# @see SknSettings

module SknUtils

  class SknConfiguration < NestedResult

    def initialize(params={})
      default_mode = defined?(Rails) ? Rails.env : ENV.fetch('RAILS_ENV', 'development') 
      @config_filename = params.is_a?(String) ? params : params.fetch(:config_filename, default_mode)
      @base_path = ENV.fetch('TEST_GEM', 'rails').eql?('gem') ? './spec/factories/' : './config/'
      load_config_basename!(@config_filename)
    end

    def load_config_basename!(conf)
      reset_from_empty!(load_config(conf))
      self
    end

    private

    def load_config(conf)
      yname   = "#{@base_path}settings.yml"
        return {} unless File.exist?(yname)
        f_base  = load_yml_with_erb(yname)

      yname   = "#{@base_path}settings/#{conf}.yml"
        f_env   = load_yml_with_erb(yname) if File.exist?(yname)
        f_base  = f_base.deeper_merge!(f_env) unless (f_env.nil? || f_env.empty?)

      yname   = "#{@base_path}settings/#{conf}.local.yml"
        f_local = load_yml_with_erb(yname)  if File.exist?(yname)
        f_base  = f_base.deeper_merge!(f_local) unless (f_local.nil? || f_local.empty?)

      f_base
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