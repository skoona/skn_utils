#
# @see SknSettings

module SknUtils

  class SknConfiguration < NestedResult

    def initialize(params={})
      default_mode = defined?(Rails) ? Rails.env : 'development'
      app_mode = params.is_a?(String) ? params : params.fetch(:config_filename, default_mode)
      load_config_basename!(load_config(app_mode))
    end

    def load_config_basename!(base_name)
      reset_from_empty!(load_config(base_name))
    end

    private

    def load_config(base_name)
      yname   = "./config/settings.yml"
      return {} unless File.exist?(yname)

      f_base  = load_yml_with_erb(yname)

      yname   = "./config/settings/#{base_name}.yml"
      f_env   = load_yml_with_erb(yname) if File.exist?(yname)
      f_base  = f_base.deep_merge(f_env) if f_env.present?

      yname   = "./config/settings/#{base_name}.local.yml"
      f_local = load_yml_with_erb(yname)  if File.exist?(yname)
      f_base  = f_base.deep_merge(f_local) if f_local.present?

      f_base
    end

    def load_yml_with_erb(yml_file)
      fname = yml_file.end_with?('.yml') ? yml_file : "#{yml_file}.yml"
      erb = ERB.new(File.read(fname)).result
      erb.present? ? YAML.load(erb).to_hash : {}
    end
  end

end