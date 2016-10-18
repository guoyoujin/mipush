lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
Dir[File.dirname(__FILE__) + '/lib/*.rb'].each {|file| require file }
@xiaomipush_service = Xiaomipush::Service.config do |s|
  s.sandbox = false # default false
  s.ios_secret = "ios secret key"
  s.bundle_id = "com.xxx.ios"
  s.android_secret = 'android secret key'
  s.package_name = "io.mdrtwell.mipushdemo"
  s.connection_adapter = :net_http # default
end
# just iOS
@message1 = @xiaomipush_service.build(:ios, description: 'hello')
@xiaomipush_service.push(:all, @message1)

@message2 = @xiaomipush_service.build(:ios, description: 'hello alias', extra: {pid: 111})
@xiaomipush_service.push(:alias, @message2, alias: '1043478')

@message3 = @xiaomipush_service.build(:ios, description: 'hello topic', extra: {pid: 111})
@xiaomipush_service.push(:topic, @message2, topic: 'all')

#multi_topic
@message3 = @xiaomipush_service.build(:ios, description: 'hello topic', extra: {pid: 111})
@xiaomipush_service.push(:topics, @message2, topics: ['all', "other"])

# iOS and Android
@message3 = @xiaomipush_service.build(:both, title: "I'm title", description: 'push to iOS and Android client')
@xiaomipush_service.push(:all, @message3)

#user_account (推送到指定用户id格式为单个"1234"，多个"1234,12345,123456")
handle_message = @xiaomipush_service.build(:android, title: "【你好测试", description: "测试", notify_id: 0, :pass_through => "jsdnnsd", extra:{notify_effect: 1, intent_uri: 'com.test.SplashActivity'})
result = @xiaomipush_service.push(:user_account, handle_message, user_account: "123456")