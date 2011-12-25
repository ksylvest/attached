class ImagesController < ApplicationController
  
  respond_to :html
  
  # GET /images
  def index
    @images = Image.all

    respond_with(@images)
  end

  # GET /images/1
  def show
    @image = Image.find(params[:id])

    respond_with(@image)
  end

  # GET /images/new
  def new
    @image = Image.new

    respond_with(@image)
  end

  # GET /images/1/edit
  def edit
    @image = Image.find(params[:id])

    respond_with(@image)
  end

  # POST /images
  def create
    @image = Image.create(params[:image])
    @image.save

    respond_with(@image)
  end

  # PUT /images/1
  def update
    @image = Image.find(params[:id])

    respond_with(@image)
  end

  # DELETE /images/1
  def destroy
    @image = Image.find(params[:id])
    @image.destroy

    respond_with(@image)
  end
  
end
