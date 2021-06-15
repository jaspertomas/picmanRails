class Product < ApplicationRecord
    # has_many :images, as: :imagable
    has_one_attached :image

    def last_image
		images=self.images.where(is_published:true)
		return nil if(images.count==0)
		images.last.image
	  end
	  def image_url
		images=self.images.where(is_published:true)
		return nil if(images.count==0)
		images.last.url
	  end
	  def gen_image_from_multipart_form_data(data,filename,user)
		image=Image.create!(imagable:self, created_by: user)
		image.gen_image_from_multipart_form_data(data,filename)
		image
	  end
	  def gen_image_from_path(hash)
		  image=Image.create!(imagable:self)
		  image.gen_image_from_path(hash)
		  image
	  end
  
end
