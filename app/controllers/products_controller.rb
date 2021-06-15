class ProductsController < ApplicationController
  before_action :set_product, only: %i[ show edit update destroy conservative_convert generous_convert]
  skip_before_action :verify_authenticity_token, only: [:create_and_convert]

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

  # POST /products or /products.json
  def create_and_convert

    #validate user app token here

    mode=params["mode"]
    success=false
    @product = Product.new(product_params)

    respond_to do |format|
      if @product.save
        format.html { redirect_to @product, notice: "Product was successfully created." }
        format.json {
          if mode && mode=="c"
            success=@product.conservative_convert
          else
            success=@product.generous_convert
          end
          if success
            return render json: {success: true, data: {
              image_url: Rails.application.routes.url_helpers.rails_blob_path(@product.converted_image, only_path: true),
            }}
          else
            return render json: {success: false}
            end
        }
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

  def conservative_convert
    success=@product.conservative_convert
    if success
      respond_to do |format|
        format.html { redirect_to @product, notice: "Image was successfully converted." }
        format.json {
          return render json: {success: true, data: {
            image_url: Rails.application.routes.url_helpers.rails_blob_path(@product.converted_image, only_path: true),
          }}}
        end
    else
      respond_to do |format|
        format.html { redirect_to @product, notice: "Error converting image." }
        return render json: {success: false}
        end
    end
  end

  def generous_convert
    success=@product.generous_convert
    if success
      respond_to do |format|
        format.html { redirect_to @product, notice: "Image was successfully converted." }
        format.json {
          return render json: {success: true, data: {
            image_url: Rails.application.routes.url_helpers.rails_blob_path(@product.converted_image, only_path: true),
          }}}
        end
    else
      respond_to do |format|
        format.html { redirect_to @product, notice: "Error converting image." }
        return render json: {success: false}
        end
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
