require "./slack-incoming-webhooks/*"

require "json"
require "uri"
require "http/client"

module Slack
  module Incoming
    class Webhooks
      getter :payload

      def initialize(@url : String,
                     as_user = nil,
                     attachments = nil,
                     channel = nil,
                     icon_emoji = nil,
                     icon_url = nil,
                     link_names = nil,
                     parse = nil,
                     token = nil,
                     unfurl_links = nil,
                     unfurl_media = nil,
                     username = nil)
        @payload = Payload.new(
          as_user: as_user,
          attachments: attachments,
          channel: channel,
          icon_emoji: icon_emoji,
          icon_url: icon_url,
          link_names: link_names,
          parse: parse,
          token: token,
          unfurl_links: unfurl_links,
          unfurl_media: unfurl_media,
          username: username
        )
      end

      # explicit setter
      def set_as_user(as_user : String)
        @payload.as_user = as_user
      end

      def set_attachments(attachments : Array(Attachment))
        @payload.attachments = attachments
      end

      def set_channel(channel : String)
        @payload.channel = channel
      end

      def set_icon_emoji(icon_emoji : String)
        @payload.icon_emoji = icon_emoji
      end

      def set_icon_url(icon_url : String)
        @payload.icon_url = icon_url
      end

      def set_link_names(link_names : Int32)
        @payload.link_names = link_names
      end

      def set_parse(parse : String)
        @parload.parse = parse
      end

      def set_toke(token : String)
        @payload.token = token
      end

      def set_unfurl_links(unfurl_links : String)
        @payload.unfurl_links = unfurl_links
      end

      def set_unfurl_media(unfurl_media : String)
        @payload.unfurl_media = unfurl_media
      end

      def set_username(username : String)
        @payload.username = username
      end

      def post(text : String, attachments : Array(Attachment) = nil)
        @payload.post(@url, text, attachments)
      end
    end

    class Payload
      JSON.mapping({
        text:         String,
        as_user:      {type: String, nilable: true, emit_null: true},
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

      def initialize(@as_user = nil,
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
        @text = ""
      end

      def post(url : String, text : String, attachments : Array(Attachment)?)
        @text = text
        @attachments = attachments unless attachments.nil?
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
end
