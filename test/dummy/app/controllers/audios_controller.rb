class AudiosController < ApplicationController

  respond_to :html

  # GET /audios
  def index
    @audios = Audio.all

    respond_with(@audios)
  end

  # GET /audios/1
  def show
    @audio = Audio.find(params[:id])

    respond_with(@audio)
  end

  # GET /audios/new
  def new
    @audio = Audio.new

    respond_with(@audio)
  end

  # GET /audios/1/edit
  def edit
    @audio = Audio.find(params[:id])
  
    respond_with(@audio)
  end

  # POST /audios
  def create
    @audio = Audio.create(attributes)

    respond_with(@audio)
  end

  # PUT /audios/1
  def update
    @audio = Audio.find(params[:id])
    @audio.attributes = attributes
    @audio.save
  
    respond_with(@audio)
  end

  # DELETE /audios/1
  def destroy
    @audio = Audio.find(params[:id])
    @audio.destroy

    respond_with(@audio)
  end

private

  def attributes
    params.require(:audio).permit(:name, :file)
  end

end
