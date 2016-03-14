require "./spec_helper"

describe Slack::IncomingWebhooks do
  it "has a version number" do
    Slack::IncomingWebhooks::VERSION.should_not be_nil
  end

  slack = Slack::IncomingWebhooks.new("TEST_WEBHOOK_URL")

  it "initializes from json" do
    slack = Slack::IncomingWebhooks.from_json(%({
      "text": "some_text",
      "channel": "some_channel",
      "icon_emoji": "some_emoji",
      "icon_url": "some_url",
      "username": "some_username",
      "attachments": [{"text": "text","fallback": "fallback"}]
      }))
    slack.text.should eq("some_text")
    slack.channel.should eq("some_channel")
    slack.icon_emoji.should eq("some_emoji")
    slack.icon_url.should eq("some_url")
    slack.username.should eq("some_username")
    (slack.attachments as Array(Slack::Attachment))[0].text.should eq("text")
    (slack.attachments as Array(Slack::Attachment))[0].fallback.should eq("fallback")
  end

  it "set channel" do
    slack.channel = "#changed channel"
    slack.channel.should eq("#changed channel")
  end
  it "set icon_emoji" do
    slack.icon_emoji = "foo"
    slack.icon_emoji.should eq("foo")
  end
  it "set icon_url" do
    slack.icon_url = "https://www.google.com"
    slack.icon_url.should eq("https://www.google.com")
  end
  it "set username" do
    slack.username = "changed username"
    slack.username.should eq("changed username")
  end
  it "set attachments" do
    attachments = [Slack::Attachment.new(title: "title", text: "text")]
    slack.attachments = attachments
    (slack.attachments as Array(Slack::Attachment))[0].title.should eq("title")
    (slack.attachments as Array(Slack::Attachment))[0].text.should eq("text")
  end
end

describe Slack::Attachment do
  it "attachment" do
    attachment = Slack::Attachment.new(
      color: "red",
      fallback: "fallback",
      title: "title",
      text: "text")
    attachment.color.should eq("red")
    attachment.fallback.should eq("fallback")
    attachment.title.should eq("title")
    attachment.text.should eq("text")
  end

  it "add_field" do
    attachment = Slack::Attachment.new
    field = Slack::AttachmentField.new("title", "value", false)
    attachment.add_field(field)
    field_array = attachment.fields as Array(Slack::AttachmentField)
    field_array.size.should eq(1)
    field_array[0].title.should eq("title")
    field_array[0].value.should eq("value")
    field_array[0].short.should be_false
  end

  it "add_fields*" do
    attachment = Slack::Attachment.new
    field1 = Slack::AttachmentField.new("title1", "value1", false)
    field2 = Slack::AttachmentField.new("title2", "value2", true)
    attachment.add_fields(field1, field2)
    field_array = attachment.fields as Array(Slack::AttachmentField)
    field_array.size.should eq(2)
    field_array[0].title.should eq("title1")
    field_array[0].value.should eq("value1")
    field_array[0].short.should be_false
    field_array[1].title.should eq("title2")
    field_array[1].value.should eq("value2")
    field_array[1].short.should be_true
  end
  it "add_fields(Array ver)" do
    attachment = Slack::Attachment.new
    fields = [
      Slack::AttachmentField.new("title1", "value1", false),
      Slack::AttachmentField.new("title2", "value2", true),
      Slack::AttachmentField.new("title3", "value3", false),
    ]
    attachment.add_fields(fields)
    field_array = attachment.fields as Array(Slack::AttachmentField)
    field_array.size.should eq(3)
    field_array[0].title.should eq("title1")
    field_array[0].value.should eq("value1")
    field_array[0].short.should be_false
    field_array[1].title.should eq("title2")
    field_array[1].value.should eq("value2")
    field_array[1].short.should be_true
    field_array[2].title.should eq("title3")
    field_array[2].value.should eq("value3")
    field_array[2].short.should be_false
  end
end
