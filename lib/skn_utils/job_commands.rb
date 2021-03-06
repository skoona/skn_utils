# ##
#
# Ref: https://yukimotopress.github.io/http

module SknUtils
  # #################################################
  #
  class CommandJSONPDelete
    def self.call(options)  # {full_url:,username:,userpass:,payload:,headers:}
      new(options)
    end

    def json?
      true
    end

    def uri
      @_uri
    end

    def request
      req = @_headers.nil? ? Net::HTTP::Delete.new(uri.request_uri) : Net::HTTP::Delete.new(uri.request_uri, @_headers)        # Generate HTTPRequest object
      req.basic_auth(@_username, @_userpass) if credentials?
      req.content_type = 'application/json'
      req.body = formatted_data
      req
    end

    private

    def initialize(opts={})
      @_username = opts[:username]
      @_userpass = opts[:userpass]
      @_headers  = opts[:headers]
      @_uri      = URI.parse( opts[:full_url])
      @_data     = opts[:payload]
    end

    def formatted_data
      @_data.respond_to?(:to_json) ? @_data.to_json : @_data
    end

    def credentials?
      !(@_username.nil? || @_userpass.nil?)
    end
  end

  # #################################################
  #
  class CommandJSONPost
    def self.call(options)  # {full_url:,username:,userpass:,payload:,headers:}
      new(options)
    end

    def json?
      true
    end

    def uri
      @_uri
    end

    def request
      req = @_headers.nil? ? Net::HTTP::Post.new(uri.path) : Net::HTTP::Post.new(uri.path, @_headers)        # Generate HTTPRequest object
      req.basic_auth(@_username, @_userpass) if credentials?
      req.content_type = 'application/json'
      req.body = formatted_data
      req
    end

  private

    def initialize(opts={})
      @_username = opts[:username]
      @_userpass = opts[:userpass]
      @_headers  = opts[:headers]
      @_uri      = URI.parse( opts[:full_url])
      @_data     = opts[:payload]
    end

    def formatted_data
      @_data.respond_to?(:to_json) ? @_data.to_json : @_data
    end

    def credentials?
      !(@_username.nil? || @_userpass.nil?)
    end
  end


  # #################################################
  #
  class CommandFORMPost
    def self.call(options)  # {full_url:,username:,userpass:,payload:,headers:}
      new(options)
    end

    def json?
      false
    end

    def uri
      @_uri
    end

    def request
      req = @_headers.nil? ? Net::HTTP::Post.new(uri.path) : Net::HTTP::Post.new(uri.path, @_headers)        # Generate HTTPRequest object
      req.basic_auth(@_username, @_userpass) if credentials?
      req.content_type = 'application/x-www-form-urlencoded'
      req.set_form_data(formatted_data)
      req
    end

    private

    def initialize(opts={})
      @_username = opts[:username]
      @_userpass = opts[:userpass]
      @_headers  = opts[:headers]
      @_uri      = URI.parse( opts[:full_url])
      @_data     = opts[:payload]
    end

    def formatted_data
      @_data
    end

    def credentials?
      !(@_username.nil? || @_userpass.nil?)
    end
  end


  # #################################################
  #
  class CommandJSONGet
    def self.call(options)  # {full_url:,username:,userpass:,headers:}
      new(options)
    end

    def json?
      true
    end

    def uri
      @_uri
    end

    def request
      req = @_headers.nil? ? Net::HTTP::Get.new(uri.request_uri) : Net::HTTP::Get.new(uri.request_uri, @_headers)        # Generate HTTPRequest object
      req.basic_auth(@_username, @_userpass) if credentials?
      req
    end

    private

    def initialize(opts={})
      @_username = opts[:username]
      @_userpass = opts[:userpass]
      @_headers  = opts[:headers]
      @_uri      = URI.parse( opts[:full_url])
    end

    def credentials?
      !(@_username.nil? || @_userpass.nil?)
    end
  end


  # #################################################
  #
  class CommandJSONPut
    def self.call(options)  # {full_url:,username:,userpass:,payload:,headers:}
      new(options)
    end

    def json?
      true
    end

    def uri
      @_uri
    end

    def request
      req = @_headers.nil? ? Net::HTTP::Put.new(uri.path) : Net::HTTP::Put.new(uri.path, @_headers)        # Generate HTTPRequest object
      req.basic_auth(@_username, @_userpass) if credentials?
      req.content_type = 'application/json'
      req.body = formatted_data
      req
    end

    private

    def initialize(opts={})
      @_username = opts[:username]
      @_userpass = opts[:userpass]
      @_headers  = opts[:headers]
      @_uri      = URI.parse( opts[:full_url])
      @_data     = opts[:payload]
    end

    def formatted_data
      @_data.respond_to?(:to_json) ? @_data.to_json : @_data
    end

    def credentials?
      !(@_username.nil? || @_userpass.nil?)
    end
  end


  # #################################################
  #
  class CommandFORMDelete
    def self.call(options)  # {full_url:,username:,userpass:}
      new(options)
    end

    def json?
      false
    end

    def uri
      @_uri
    end

    def request
      req = @_headers.nil? ? Net::HTTP::Delete.new(uri.request_uri) : Net::HTTP::Delete.new(uri.request_uri, @_headers)        # Generate HTTPRequest object
      req.basic_auth(@_username, @_userpass) if credentials?
      req
    end

    private

    def initialize(opts={})
      @_username = opts[:username]
      @_userpass = opts[:userpass]
      @_headers  = opts[:headers]
      @_uri      = URI.parse( opts[:full_url])
    end

    def credentials?
      !(@_username.nil? || @_userpass.nil?)
    end
  end
end