require 'net/http'
require 'faraday'

module Xiaomipush
  class HttpBase
    attr_accessor :secret_key, :url, :host

    def initialize(host="", secret_key="", connection_adapter = :net_http, headers={})
      @host = host
      @secret_key = secret_key
      @connection_adapter = connection_adapter
      @headers = headers
    end

    def post(url, body={});  conn.post url, body end
    def get(url, params={}); conn.get url, params end

    def conn
      headers = {authorization: "key=#{@secret_key}"}.merge(@headers)
      Faraday.new(:url => @host, :headers => headers) do |faraday|
        faraday.request  :url_encoded
        # faraday.response :logger
        faraday.options.timeout = 5           # open/read timeout in seconds
        faraday.options.open_timeout = 2      # connection open timeout in seconds
        faraday.adapter  @connection_adapter 
      end
    end

  end
end
