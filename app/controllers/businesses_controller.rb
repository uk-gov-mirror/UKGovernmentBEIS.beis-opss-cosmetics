class BusinessesController < ApplicationController
  include BusinessesHelper
  before_action :authenticate_user!
  before_action :set_business, only: %i[show edit update destroy]
  before_action :create_business, only: %i[create]
  before_action :update_business, only: %i[update]

  # GET /businesses
  # GET /businesses.json
  def index
    @businesses = if params[:q].blank?
                    Business.paginate(page: params[:page], per_page: 20)
                  else
                    search_for_businesses(20)
                  end
  end

  # GET /businesses/1
  # GET /businesses/1.json
  def show
    @investigations = @business.investigations
    return unless @business.from_companies_house?
    PaperTrail.request.whodunnit = nil # This will stop papertrail recording the current user
    CompaniesHouseClient.instance.update_business_from_companies_house(@business)
  end

  # GET /businesses/new
  def new
    @business = Business.new
    @business.addresses.build
  end

  # GET /businesses/1/edit
  def edit
    @business.addresses.build unless @business.addresses.any?
  end

  # GET /businesses/search
  def search
    @existing_businesses = search_for_businesses(BUSINESS_SUGGESTION_LIMIT)
    @companies_house_businesses = search_companies_house(params[:q], BUSINESS_SUGGESTION_LIMIT)
    render partial: "search_results"
  end

  # POST /businesses/companies_house
  def companies_house
    @business = CompaniesHouseClient.instance.create_business_from_companies_house_number params[:company_number]
    respond_to_business_creation
  end

  # POST /businesses
  # POST /businesses.json
  def create
    respond_to_business_creation
  end

  # PATCH/PUT /businesses/1
  # PATCH/PUT /businesses/1.json
  def update
    respond_to do |format|
      if @business.save
        format.html { redirect_to @business, notice: "Business was successfully updated." }
        format.json { render :show, status: :ok, location: @business }
      else
        format.html { render :edit }
        format.json { render json: @business.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /businesses/1
  # DELETE /businesses/1.json
  def destroy
    @business.destroy
    respond_to do |format|
      format.html { redirect_to businesses_url, notice: "Business was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def create_business
    @business = Business.new(business_params)
    defaults_on_primary_address(@business) if @business.addresses.any?
    @business.source = UserSource.new(user: current_user)
  end

  def set_business
    @business = Business.find(params[:id])
  end

  def update_business
    @business.assign_attributes(business_params)
    defaults_on_primary_address(@business) if @business.addresses.any?
  end

  def respond_to_business_creation
    respond_to do |format|
      if @business.save
        format.html { redirect_to @business, notice: "Business was successfully created." }
        format.json { render :show, status: :created, location: @business }
      else
        format.html { render :new }
        format.json { render json: @business.errors, status: :unprocessable_entity }
      end
    end
  end
end
