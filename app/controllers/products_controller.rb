class ProductsController < ApplicationController
  before_action :set_product, only: %i[ show edit update destroy convert]

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
    rails_path= Dir.pwd
    image=@product.images[0]
    key=image.image.blob.key
    path=rails_path+"/storage/"+key[0,2]+"/"+key[2,2]+"/"+key
    #path = d:/src/picmanRails/storage/6a/3w/6a3wn80hov9h1nx3pct9qrli8ynk
print("cd D:\\src\\image-background-remove-tool & python3 main.py -i "+path+" -o .\\docs\\imgss\\outputt\\ -m u2net")
    s=system("cd D:\\src\\image-background-remove-tool & python3 main.py -i "+path+" -o .\\docs\\imgss\\outputt\\ -m u2net")
    # print(s)

    # return render json: {success: true, message: "hello world!"}
    return render json: "hello world!"

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
