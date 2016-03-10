require "./spec_helper"

describe Slack::Incoming::Webhooks do
  describe Slack::Incoming::Webhooks::Payload do
    it "initializes from json" do
      payload = Slack::Incoming::Webhooks::Payload.from_json(%({
      "text": "some_text",
      "channel": "some_channel",
      "icon_emoji": "some_emoji",
      "icon_url": "some_url",
      "username": "some_username"
      }))
      payload.text.should eq("some_text")
      payload.channel.should eq("some_channel")
      payload.icon_emoji.should eq("some_emoji")
      payload.icon_url.should eq("some_url")
      payload.username.should eq("some_username")
    end
  end
  describe Slack::Incoming::Webhooks::Hook do
    it "post" do
      hook = Slack::Incoming::Webhooks::Hook.new(ENV["WEBHOOK_URL"])
      resp = hook.post("text")
      (resp.body).should eq("ok")
    end
    it "attachment(no fields)" do
      hook = Slack::Incoming::Webhooks::Hook.new(ENV["WEBHOOK_URL"])
      attachments = [Slack::Incoming::Webhooks::Attachment.new(title: "test", text: "TEST")]
      resp = hook.post("text", attachments: attachments)
      (resp.body).should eq("ok")
    end
    it "attachment(fields)" do
      hook = Slack::Incoming::Webhooks::Hook.new(ENV["WEBHOOK_URL"])
      attachments = [Slack::Incoming::Webhooks::Attachment.new(title: "test", text: "TEST")]
      field1 = Slack::Incoming::Webhooks::AttachmentField.new("title", "value", false)
      field2 = Slack::Incoming::Webhooks::AttachmentField.new("TITLE", "VALUE", true)
      field3 = Slack::Incoming::Webhooks::AttachmentField.new("TiTlE", "vAlUe", true)
      attachments[0].add_fields([field1, field2, field3])
      resp = hook.post("text", attachments: attachments)
      (resp.body).should eq("ok")
    end
  end
end
