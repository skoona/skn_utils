# File: ./lib/skn_utils/env_string_handler.rb
#
# Wrapping a string in this class gives you a prettier way to test
# for equality. The value returned by <tt>Rails.env</tt> is wrapped
# in a StringInquirer object so instead of calling this:
#
#   Rails.env == 'production'
#   SknSettings.env == 'production'
#
# you can call this:
#
#   Rails.env.production?
#   SknSettings.env.productcion?
#
# Create a EnvStringHandler to support: SknSettings.env.development?
# Yes, its YAML trick
# in config/settings.yml
#   ...
#   env: !ruby/string:EnvStringHandler <%= ENV['RACK_ENV'] %>
#   ...
# #
class EnvStringHandler < String
  private

  def respond_to_missing?(method_name, _include_private = false)
    method_name[-1] == '?'
  end

  def method_missing(method_name, *arguments)
    if method_name[-1] == '?'
      self == method_name[0..-2]
    else
      super
    end
  end
end
