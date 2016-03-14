require "json"
require "uri"
require "http/client"
require "./Attachment"

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
      # @url must be String, but this @url is String?
      # due to url is not in json mapping?
      # @url = "" in initialize does not work...
      HTTP::Client.post_form @url as String, "payload=#{URI.escape to_json}"
    end
  end
end
