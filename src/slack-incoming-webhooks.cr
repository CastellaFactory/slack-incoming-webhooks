require "./slack-incoming-webhooks/*"

require "json"
require "uri"
require "http/client"

module Slack::Incoming::Webhooks
  class Connection
    def initialize(@url : String,
                   channel = nil,
                   icon_emoji = nil,
                   icon_url = nil,
                   username = nil)
      @payload = Payload.new(channel: channel, icon_emoji: icon_emoji, icon_url: icon_url, username: username)
    end

    def post(text : String, attachments : Array(Attachment) = nil)
      @payload.post(@url, text, attachments)
    end
  end

  class Payload
    JSON.mapping({
      text:        String,
      channel:     {type: String, nilable: true, emit_null: true},
      icon_emoji:  {type: String, nilable: true, emit_null: true},
      icon_url:    {type: String, nilable: true, emit_null: true},
      username:    {type: String, nilable: true, emit_null: true},
      attachments: {type: Array(Attachment), nilable: true, emit_null: true},
    })

    def initialize(@channel = nil,
                   @icon_emoji = nil,
                   @icon_url = nil,
                   @username = nil)
      @text = ""
    end

    def post(url : String, text : String, attachments : Array(Attachment)?)
      @text = text
      @attachments = attachments
      HTTP::Client.post_form url, "payload=#{URI.escape to_json}"
    end
  end

  class AttachmentField
    JSON.mapping({
      title: String,
      value: {type: String, nilable: true, emit_null: true},
      short: {type: Bool, nilable: true, emit_null: true},
    })

    def initialize(@title, @value, @short = false)
    end
  end

  class Attachment
    JSON.mapping({
      color:       {type: String, nilable: true, emit_null: true},
      fallback:    {type: String, nilable: true},
      author_name: {type: String, nilable: true, emit_null: true},
      author_link: {type: String, nilable: true, emit_null: true},
      author_icon: {type: String, nilable: true, emit_null: true},
      title:       {type: String, nilable: true, emit_null: true},
      title_link:  {type: String, nilable: true, emit_null: true},
      text:        {type: String, nilable: true},
      fields:      Array(AttachmentField),
      image_url:   {type: String, nilable: true, emit_null: true},
      thumb_url:   {type: String, nilable: true, emit_null: true},
    })

    def initialize(@color = nil,
                   @fallback = nil,
                   @author_name = nil,
                   @author_link = nil,
                   @author_icon = nil,
                   @title = nil,
                   @title_link = nil,
                   @text = nil,
                   @fields = [] of AttachmentField,
                   @image_url = nil,
                   @thumb_url = nil)
    end

    def add_field(field : AttachmentField)
      @fields.push(field)
    end

    def add_fields(*fields : AttachmentField)
      @fields.push(*fields)
    end

    def add_fields(fields : Array(AttachmentField))
      fields.each do |field|
        @fields.push(field)
      end
    end
  end
end
