require './lib/xiaomipush/xm_resources'
require './lib/xiaomipush/http_base'
require './lib/xiaomipush/message'
require './lib/xiaomipush/android_builder'
require './lib/xiaomipush/ios_builder'
require './lib/xiaomipush/targeted_message'
require './lib/xiaomipush/stats'
require './lib/xiaomipush/subscription'
require './lib/xiaomipush/tracer'
require './lib/xiaomipush/feedback'

module Xiaomipush
  class Service

    attr_accessor :ios_secret, :android_secret, :bundle_id, :package_name, :connection_adapter, :sandbox

    def initialize(ios_secret: "", android_secret: "", bundle_id: "", package_name: "", connection_adapter: :net_http, sandbox: false)
      @sandbox = sandbox
      @ios_secret = ios_secret
      @bundle_id = bundle_id
      @android_secret = android_secret
      @package_name = package_name
      @connection_adapter = connection_adapter
    end

    def self.config
      yield service = new; service
    end

    def build(build_type, message={})
      case build_type
      when :ios
        build_message = { ios: ios_builder(message)}
      when :android
        build_message = { android: android_builder(message) }
      when :both
        build_message = { ios: ios_builder(message),  android: android_builder(message)}
      end
      return build_message
    end

    def push(push_type, message, options={})
      case push_type
      when :alias
        return "must input alias" unless options[:alias]
        message.values.each{|v| v.merge!(alias: options[:alias])}
        resource_post('alias', message)
      when :regid
        return "must input regid" unless options[:regid]
        message.values.each{|v| v.merge!(regid: options[:regid])}
        resource_post('regid', message)
      when :topic
        return "must input topic" unless options[:topic]
        message.values.each{|v| v.merge!(topic: options[:topic])}
        resource_post('topic', message)
      when :topics
        return "must input topics" unless options[:topics]
        message.values.each{|v| v.merge!(topics: options[:topics].join(";$;"), topic_op: options[:topic_op] || "UNION")}
        resource_post('mtopic', message)
        # ws add
      when :user_account
        return "must input user_account" unless options[:user_account]
        message.values.each{|v| v.merge!(user_account: options[:user_account].class.to_s == 'Array' ? options[:user_account].join(',') : options[:user_account])}
        resource_post('user_account', message)
      when :all
        resource_post('all', message)
      end
    end

    private

    def ios_builder(message={})
      message[:restricted_package_name] = @bundle_id
      IosBuilder.new(message).build
    end

    def android_builder(message={})
      message[:restricted_package_name] = @package_name
      AndroidBuilder.new(message).build
    end

    def ios_http
      host = @sandbox ? Xiaomipush::XmResource::SANDBOX_DOMAIN : Xiaomipush::XmResource::OFFICIAL_DOMAIN
      Xiaomipush::HttpBase.new(host, @ios_secret, @connection_adapter)
    end

    def android_http
      # return "android don't support sandbox" if @sandbox
      host = Xiaomipush::XmResource::OFFICIAL_DOMAIN
      Xiaomipush::HttpBase.new(host, @android_secret, @connection_adapter)
    end

    def resource_post(name, message)
      ios_http.post(Xiaomipush::XmResource.const_get("#{name.upcase}_URL"), message[:ios]) if message[:ios]
      android_http.post(Xiaomipush::XmResource.const_get("#{name.upcase}_URL"), message[:android]) if message[:android]
    end

  end
end