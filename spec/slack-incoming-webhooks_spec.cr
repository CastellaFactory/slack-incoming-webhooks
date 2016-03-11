require "./spec_helper"

describe Slack::Incoming::Payload do
  it "initializes from json" do
    payload = Slack::Incoming::Payload.from_json(%({
      "text": "some_text",
      "channel": "some_channel",
      "icon_emoji": "some_emoji",
      "icon_url": "some_url",
      "username": "some_username",
      "attachments": [{"text": "text","fallback": "fallback"}]
      }))
    payload.text.should eq("some_text")
    payload.channel.should eq("some_channel")
    payload.icon_emoji.should eq("some_emoji")
    payload.icon_url.should eq("some_url")
    payload.username.should eq("some_username")
    (payload.attachments as Array(Slack::Incoming::Attachment))[0].text.should eq("text")
    (payload.attachments as Array(Slack::Incoming::Attachment))[0].fallback.should eq("fallback")
  end
end

describe Slack::Incoming::Webhooks do
  it "has a version number" do
    Slack::Incoming::Webhooks::VERSION.should_not be_nil
  end

  slack = Slack::Incoming::Webhooks.new("TEST_WEBHOOK_URL")

  it "set_channel" do
    slack.set_channel "#changed channel"
    slack.payload.channel.should eq("#changed channel")
  end

  it "set_icon_emoji" do
    slack.set_icon_emoji "foo"
    slack.payload.icon_emoji.should eq("foo")
  end

  it "set_icon_url" do
    slack.set_icon_url "https://www.google.com"
    slack.payload.icon_url.should eq("https://www.google.com")
  end

  it "set_username" do
    slack.set_username "changed username"
    slack.payload.username.should eq("changed username")
  end

  it "set_attachments" do
    attachments = [Slack::Incoming::Attachment.new(title: "title", text: "text")]
    slack.set_attachments attachments
    (slack.payload.attachments as Array(Slack::Incoming::Attachment))[0].title.should eq("title")
    (slack.payload.attachments as Array(Slack::Incoming::Attachment))[0].text.should eq("text")
  end
end

describe Slack::Incoming::Attachment do
  it "attachments" do
    attachments = [Slack::Incoming::Attachment.new(
      color: "red",
      fallback: "fallback",
      title: "title",
      text: "text")]
    attachments.[0].color.should eq("red")
    attachments.[0].fallback.should eq("fallback")
    attachments.[0].title.should eq("title")
    attachments.[0].text.should eq("text")
  end

  it "add_field" do
    attachment = Slack::Incoming::Attachment.new
    field = Slack::Incoming::AttachmentField.new("title", "value", false)
    attachment.add_field(field)
    field_array = attachment.fields as Array(Slack::Incoming::AttachmentField)
    field_array.size.should eq(1)
    field_array[0].title.should eq("title")
    field_array[0].value.should eq("value")
    field_array[0].short.should be_false
  end

  it "add_fields*" do
    attachment = Slack::Incoming::Attachment.new
    field1 = Slack::Incoming::AttachmentField.new("title1", "value1", false)
    field2 = Slack::Incoming::AttachmentField.new("title2", "value2", true)
    attachment.add_fields(field1, field2)
    field_array = attachment.fields as Array(Slack::Incoming::AttachmentField)
    field_array.size.should eq(2)
    field_array[0].title.should eq("title1")
    field_array[0].value.should eq("value1")
    field_array[0].short.should be_false
    field_array[1].title.should eq("title2")
    field_array[1].value.should eq("value2")
    field_array[1].short.should be_true
  end
  it "add_fields(Array ver)" do
    attachment = Slack::Incoming::Attachment.new
    fields = [
      Slack::Incoming::AttachmentField.new("title1", "value1", false),
      Slack::Incoming::AttachmentField.new("title2", "value2", true),
      Slack::Incoming::AttachmentField.new("title3", "value3", false),
    ]
    attachment.add_fields(fields)
    field_array = attachment.fields as Array(Slack::Incoming::AttachmentField)
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
