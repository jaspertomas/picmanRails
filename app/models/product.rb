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
        self.image.attach(io: URI.open(image.path), filename: filename, content_type: content_type)
    end
    def gen_converted_image_from_path(hash)
        path=hash[:path]
        image = MiniMagick::Image.open(path)
        # image.resize "200x200"
        filename=hash[:filename]
        content_type=hash[:content_type]
        self.converted_image.attach(io: URI.open(image.path), filename: filename, content_type: content_type)
    end


    def conservative_convert
        #formulate source image path
        rails_path= Dir.pwd
        image=self.image
        filename=image.blob.key
        path=rails_path+"/storage/"+filename[0,2]+"/"+filename[2,2]+"/"+filename
        #path = d:/src/picmanRails/storage/6a/3w/6a3wn80hov9h1nx3pct9qrli8ynk
    
        # remove background from source image
        success=system("cd D:\\src\\image-background-remove-tool & python3 main.py -i "+path+" -o .\\docs\\imgss\\outputt\\ -m u2net")
        if(success)
          # attach image with background removed
          self.gen_converted_image_from_path(path:"D:\\src\\image-background-remove-tool\\docs\\imgss\\outputt\\"+filename+".png", filename: filename+'.png', content_type: 'image/png')
        end
        return success
      end
    
      def generous_convert
        #formulate source image path
        rails_path= Dir.pwd
        image=self.image
        filename=image.blob.key
        path=rails_path+"/storage/"+filename[0,2]+"/"+filename[2,2]+"/"+filename
        #path = d:/src/picmanRails/storage/6a/3w/6a3wn80hov9h1nx3pct9qrli8ynk
    
        # remove background from source image
        #hi quality version
        #success=system("cd D:\\src\\image-background-removal & python3 seg.py "+path+" output\\"+filename+".png"+" 1")
        #low quality version
        success=system("cd D:\\src\\image-background-removal & python3 seg.py "+path+" output\\"+filename+".png")
        if(success)
          # attach image with background removed
          self.gen_converted_image_from_path(path:"D:\\src\\image-background-removal\\output\\"+filename+".png", filename: filename+'.png', content_type: 'image/png')
        end
        return success
      end
    
  
end
