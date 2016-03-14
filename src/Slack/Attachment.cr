require "json"

module Slack
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
