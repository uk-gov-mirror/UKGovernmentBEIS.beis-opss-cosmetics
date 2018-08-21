class Investigations::BusinessesController < ApplicationController
  include BusinessesHelper
  before_action :authenticate_user!
  before_action :set_investigation, only: %i[index new create]
  before_action :create_business, only: %i[new create]
  # GET /investigations/1/businesses
  def index
    @business = Business.new
    @business.addresses.build
  end

  # GET /investigations/1/businesses/new
  def new; end

  # GET /investigations/1/businesses/suggested
  def suggested
    excluded_business_ids = params[:excluded_businesses].split(",")
    @existing_businesses = search_for_businesses(20)
                           .reject { |business| excluded_business_ids.include?(business.id) }
                           .first(BUSINESS_SUGGESTION_LIMIT)
    @companies_house_businesses = search_companies_house(params[:q], BUSINESS_SUGGESTION_LIMIT)
    render partial: "businesses/search_results"
  end

  # POST /investigations/1/businesses
  def create
    respond_to do |format|
      if @investigation.businesses << @business
        format.html { redirect_to @investigation, notice: "Business was successfully created." }
        format.json { render :show, status: :created, location: @investigation }
      else
        format.html { render :new }
        format.json { render json: @business.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_investigation
    @investigation = Investigation.find(params[:investigation_id])
  end

  def create_business
    if params[:business]
      @business = Business.new(business_params)
      defaults_on_primary_address(@business) if @business.addresses.any?
      @business.source = UserSource.new(user: current_user)
    else
      @business = Business.new
      @business.addresses.build
    end
  end
end
