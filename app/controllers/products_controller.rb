class ProductsController < ApplicationController
  before_action :set_product, only: %i[ show edit update destroy convert]
  skip_before_action :verify_authenticity_token, only: [:create]

  # GET /products or /products.json
  def index
    @products = Product.all
  end

  # GET /products/1 or /products/1.json
  def show
  end

  # GET /products/new
  def new
    @product = Product.new
  end

  # GET /products/1/edit
  def edit
  end

  # POST /products or /products.json
  def create
    @product = Product.new(product_params)

    respond_to do |format|
      if @product.save
        format.html { redirect_to @product, notice: "Product was successfully created." }
        format.json { render :show, status: :created, location: @product }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /products/1 or /products/1.json
  def update
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to @product, notice: "Product was successfully updated." }
        format.json { render :show, status: :ok, location: @product }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1 or /products/1.json
  def destroy
    @product.destroy
    respond_to do |format|
      format.html { redirect_to products_url, notice: "Product was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def convert
    #formulate source image path
    rails_path= Dir.pwd
    image=@product.image
    filename=image.blob.key
    path=rails_path+"/storage/"+filename[0,2]+"/"+filename[2,2]+"/"+filename
    #path = d:/src/picmanRails/storage/6a/3w/6a3wn80hov9h1nx3pct9qrli8ynk

    # remove background from source image
    success=system("cd D:\\src\\image-background-remove-tool & python3 main.py -i "+path+" -o .\\docs\\imgss\\outputt\\ -m u2net")
    if(success)
      # attach image with background removed
      @product.gen_image_from_path(path:"D:\\src\\image-background-remove-tool\\docs\\imgss\\outputt\\"+filename+".png", filename: filename+'.png', content_type: 'image/png')
    end

    respond_to do |format|
      format.html { redirect_to @product, notice: "Product was successfully converted." }
      format.json { head :no_content }
    end

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def product_params
      params.require(:product).permit(:name, :image)
    end


end
