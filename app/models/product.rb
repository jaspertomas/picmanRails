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
        IO.popen("cd "+Constants::IMAGE_BACKGROUND_REMOVE_TOOL_PATH+" && python3 main.py -i "+path+" -o ./docs/imgs/output/ -m u2net")

        #file generation is delayed
        #every second for 10 seconds
        #check if output file exist
        success=false
        output_file=Constants::IMAGE_BACKGROUND_REMOVE_TOOL_PATH+"/docs/imgs/output/"+filename+".png"
        (1..10).each do |i|
          if File.exist?(output_file) 
            success=true
            break
          else
            sleep(1.second)
          end
        end

        if(success)
          # attach image with background removed
          self.gen_converted_image_from_path(path:Constants::IMAGE_BACKGROUND_REMOVE_TOOL_PATH+"/docs/imgs/output/"+filename+".png", filename: filename+'.png', content_type: 'image/png')
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
        # success=IO.popen("cd "+Constants::IMAGE_BACKGROUND_REMOVAL_PATH+" && python3 seg.py "+path+" output/"+filename+".png"+" 1")        
        #low quality version
        IO.popen("cd "+Constants::IMAGE_BACKGROUND_REMOVAL_PATH+" && python3 seg.py "+path+" output/"+filename+".png")

        #file generation is delayed
        #every second for 10 seconds
        #check if output file exist
        success=false
        output_file=Constants::IMAGE_BACKGROUND_REMOVAL_PATH+"/output/"+filename+".png"
        (1..10).each do |i|
          if File.exist?(output_file) 
            success=true
            break
          else
            sleep(1.second)
          end
        end

        if(success)
          # attach image with background removed
          self.gen_converted_image_from_path(path:Constants::IMAGE_BACKGROUND_REMOVAL_PATH+"/output/"+filename+".png", filename: filename+'.png', content_type: 'image/png')
        end
        return success
      end
end
