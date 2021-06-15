class Product < ApplicationRecord
    # has_many :images, as: :imagable
    has_one_attached :image
    has_one_attached :converted_image

    def gen_image_from_multipart_form_data(data,filename)
        #self.image.attach(io: StringIO.new(data), filename: filename)#, content_type: content_type
        image = MiniMagick::Image.read(StringIO.new(data))
        image.resize "200x200"
        self.image.attach(io: URI.open(image.path), filename: filename)
    end
    def gen_image_from_path(hash)
        path=hash[:path]
        image = MiniMagick::Image.open(path)
        # image.resize "200x200"
        filename=hash[:filename]
        content_type=hash[:content_type]
        self.converted_image.attach(io: URI.open(image.path), filename: filename, content_type: content_type)
    end
  
end
