class PeopleController < ApplicationController
  
  respond_to :html
  
  # GET /people
  def index
    @people = Person.all
    respond_with(@people)
  end
  
  # GET /people/new
  def new
    @person = Person.new
    respond_with(@person)
  end
  
  # GET /people/1
  def show
    @person = Person.find(params[:id])
    respond_with(@person)
  end
  
  # GET /people/1/edit
  def edit
    @person = Person.find(params[:id])
    respond_with(@person)
  end
  
  # PUT /people
  def create
    @person = Person.create(params[:person])
    respond_with(@person)
  end
  
  # POST /people
  def update
    @person = Person.find(params[:id])
    @person.update_attributes(params[:person])
    respond_with(@person)
  end
  
  # DELETE /people/1
  def destroy
    @person = Person.find(params[:id])
    @person.destroy
    respond_with(@person)
  end
  
end
