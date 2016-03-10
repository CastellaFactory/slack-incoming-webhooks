# slack-incoming-webhooks

Simple [Crystal](http://crystal-lang.org/) client for Slack Incoming Webhooks

## Simple Usage

``` ruby
require "slack-incoming-webhooks"

slack = Slack::Incoming::Webhooks::Hook.new(
  "Your WEBHOOK_URL",
  username: "TEST")
slack.post("text")
```

You can create more richly-formatted messages using [Attachments](https://api.slack.com/docs/attachments).

``` ruby
require "slack-incoming-webhooks"

slack = Slack::Incoming::Webhooks::Hook.new(
  "Your WEBHOOK_URL",
  username: "TEST")

attachments = [Slack::Incoming::Webhooks::Attachment.new(
  author_name: "author",
  author_icon: "http://...cool_icon.jpg",
  title: "TITLE",
  title_link: "http://google.com"
  )]

slack.post("text", attachments: attachments)
```

## Development

latest Crystal

## Contributing

1.  Fork it ( https://github.com/CastellaFactory/slack-incoming-webhooks/fork )
2.  Create your feature branch (git checkout -b my-new-feature)
3.  Commit your changes (git commit -am 'Add some feature')
4.  Push to the branch (git push origin my-new-feature)
5.  Create a new Pull Request

## Contributors

- [CastellaFactory](https://github.com/CastellaFactory) CastellaFactory - creator, maintainer
