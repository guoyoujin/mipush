# Xiaomipush

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/xiaomipush`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'xiaomipush'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install xiaomipush

## Usage
```ruby
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

```
TODO: Write usage instructions here

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/guoyoujin/xiaomipush.

