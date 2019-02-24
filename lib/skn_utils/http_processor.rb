# ##
#
#
module SknUtils

  class HttpProcessor

    def self.call(command)
      completion = false

      response = Net::HTTP.start( command.uri.host,command.uri.port,
                                  use_ssl: command.uri.scheme.eql?("https")
      ) do |http|
        http.open_timeout = 5           # in seconds, for internal http timeouts
        http.read_timeout = 15          # in seconds
        if command.uri.scheme.eql?("https")
          http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        end
        http.request(command.request)
      end

      if ( response.kind_of?(Net::HTTPClientError) or response.kind_of?(Net::HTTPServerError) )
        completion = SknFailure.call(response.code, response.message)
      else
        payload = command.json? ? JSON.load(response.body) : response.body
        completion = SknSuccess.call(payload, response.class.name)
      end

      completion
    rescue => exception
      SknFailure.call(command.uri.request_uri, "#{exception.message}; #{exception.backtrace[0]}")
    end
  end
end
