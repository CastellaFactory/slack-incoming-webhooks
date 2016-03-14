# slack-incoming-webhooks

[![Build Status](https://travis-ci.org/CastellaFactory/slack-incoming-webhooks.svg?branch=master)](https://travis-ci.org/CastellaFactory/slack-incoming-webhooks)

Simple [Crystal](http://crystal-lang.org/) library for Slack Incoming Webhooks

## Simple Usage

``` crystal
require "slack-incoming-webhooks"

slack = Slack::IncomingWebhooks.new "Your WEBHOOK_URL"
slack.post "text"
```

You can specify the channel or username or etc...

Please refer to [here](https://api.slack.com/methods/chat.postMessage).

``` crystal
Slack::IncomingWebhooks.new "Your WEBHOOK_URL", channel: "#hoge",
                                                  username: "Bot",
                                                  icon_emoji: ":ghost:"
```

### Attachments

You can create more richly-formatted messages using [Attachments](https://api.slack.com/docs/attachments).

``` crystal
require "slack-incoming-webhooks"

slack = Slack::IncomingWebhooks.new "Your WEBHOOK_URL"

attachment = Slack::Attachment.new author_name: "hoge",
                                             author_icon: "http://...cool_icon",
                                             color: "#36a64f",
                                             title: "TITLE",
                                             title_link: "https://www.google.com"

slack.post "text with attachments", attachments: [attachment]
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
