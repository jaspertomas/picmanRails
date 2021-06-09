class Image < ApplicationRecord
    #first and last by created_at coz id is uuid
    self.implicit_order_column = "created_at"

    belongs_to :imagable, polymorphic: true
    belongs_to :created_by, class_name: "User", foreign_key: "created_by_id", optional: true

    has_one_attached :image
    has_one :delete_request, as: :deletable

    def fullname
        imagable.fullname
    end

    def gen_image_from_multipart_form_data(data,filename)
        #self.image.attach(io: StringIO.new(data), filename: filename)#, content_type: content_type
        image = MiniMagick::Image.read(StringIO.new(data))
        image.resize "200x200"
        self.image.attach(io: URI.open(image.path), filename: filename)
    end
    def gen_image_from_path(hash)
        path=hash[:path]
        image = MiniMagick::Image.open(path)
        image.resize "200x200"
        filename=hash[:filename]
        content_type=hash[:content_type]
        self.image.attach(io: URI.open(image.path), filename: filename, content_type: content_type)
    end

    def url
        #if no attachment, delete self and return null
        if !self.image.attached?
            self.destroy
            return nil
        end
        Rails.application.routes.url_helpers.rails_blob_path(self.image, only_path: true)
    end   

    def cascade_delete
        self.delete_request.destroy if self.delete_request
        self.image.purge
        self.destroy
    end

    def to_formatted_hash
        {
          id: id,
          date: created_at,
          url: self.url,
        }
    end    
end
