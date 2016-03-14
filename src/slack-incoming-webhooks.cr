require "./slack-incoming-webhooks/*"

require "json"
require "uri"
require "http/client"

module Slack
  class IncomingWebhooks
    JSON.mapping({
      text:         String,
      as_user:      {type: Bool, nilable: true, emit_null: true},
      attachments:  {type: Array(Attachment), nilable: true, emit_null: true},
      channel:      {type: String, nilable: true, emit_null: true},
      icon_emoji:   {type: String, nilable: true, emit_null: true},
      icon_url:     {type: String, nilable: true, emit_null: true},
      link_names:   {type: Int32, nilable: true, emit_null: true},
      parse:        {type: String, nilable: true, emit_null: true},
      token:        {type: String, nilable: true, emit_null: true},
      unfurl_links: {type: Bool, nilable: true, emit_null: true},
      unfurl_media: {type: Bool, nilable: true, emit_null: true},
      username:     {type: String, nilable: true, emit_null: true},
    })

    def initialize(@url : String,
                   @text = "",
                   @as_user = nil,
                   @attachments = nil,
                   @channel = nil,
                   @icon_emoji = nil,
                   @icon_url = nil,
                   @link_names = nil,
                   @parse = nil,
                   @token = nil,
                   @unfurl_links = nil,
                   @unfurl_media = nil,
                   @username = nil)
    end

    def post(text : String, attachments : Array(Attachment) = nil)
      @text = text
      @attachments = attachments unless attachments.nil?
      HTTP::Client.post_form @url, "payload=#{URI.escape to_json}"
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
      author_icon: {type: String, nilable: true, emit_null: true},
      author_link: {type: String, nilable: true, emit_null: true},
      author_name: {type: String, nilable: true, emit_null: true},
      color:       {type: String, nilable: true, emit_null: true},
      fallback:    {type: String, nilable: true},
      fields:      {type: Array(AttachmentField), nilable: true, emit_null: true},
      image_url:   {type: String, nilable: true, emit_null: true},
      text:        {type: String, nilable: true},
      thumb_url:   {type: String, nilable: true, emit_null: true},
      title:       {type: String, nilable: true, emit_null: true},
      title_link:  {type: String, nilable: true, emit_null: true},
    })

    def initialize(@author_icon = nil,
                   @author_link = nil,
                   @author_name = nil,
                   @color = nil,
                   @fallback = nil,
                   @fields = nil,
                   @image_url = nil,
                   @text = nil,
                   @thumb_url = nil,
                   @title = nil,
                   @title_link = nil)
    end

    def add_field(field : AttachmentField)
      @fields = [] of AttachmentField if @fields.nil?
      # safe cast
      (@fields as Array(AttachmentField)).push(field)
    end

    def add_fields(*fields : AttachmentField)
      @fields = [] of AttachmentField if @fields.nil?
      # safe cast
      (@fields as Array(AttachmentField)).push(*fields)
    end

    def add_fields(fields : Array(AttachmentField))
      @fields = [] of AttachmentField if @fields.nil?
      fields.each do |field|
        # safe cast
        (@fields as Array(AttachmentField)).push(field)
      end
    end
  end
end
