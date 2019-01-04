class Investigations::CorrespondenceController < ApplicationController
  include FileConcern
  set_attachment_names :file
  set_file_params_key :correspondence

  include Wicked::Wizard
  steps :general_info, :content, :confirmation
  before_action :load_relevant_objects, only: %i[show update create]

  def new
    clear_session
    initialize_file_attachments
    redirect_to wizard_path(steps.first, request.query_parameters)
  end

  def create
    update_blob_metadata(@file_blob, get_attachment_metadata_params(:file))
    attach_blobs_to_list(@file_blob, @correspondence.documents)
    @investigation.correspondences << @correspondence
    @investigation.save
    AuditActivity::Correspondence::Add.from(@correspondence, @investigation)
    redirect_to investigation_path(@investigation)
  end

  def show
    render_wizard
  end

  def update
    @correspondence.validate(step)
    validate_blob_size(@file_blob, @correspondence.errors, "file")
    if @correspondence.errors.any?
      render step
    else
      redirect_to next_wizard_path
    end
  end

private

  def correspondence_params
    return {} if params[:correspondence].blank?

    handle_type_params
    params.require(:correspondence).permit(
      :correspondent_name, :correspondent_type, :contact_method, :phone_number, :email_address, :day, :month, :year,
      :overview, :details
    )
  end

  def handle_type_params
    if params[:correspondence][:correspondent_type] == 'Other'
      params[:correspondence][:correspondent_type] = params[:correspondence][:other_correspondent_type]
    end
  end

  def load_relevant_objects
    @investigation = Investigation.find_by(id: params[:investigation_id])
    @file_blob, * = load_file_attachments
    load_correspondence
  end

  def load_correspondence
    data_from_previous_steps = session[:correspondence] || suggested_values
    session[:correspondence] = data_from_previous_steps.merge(correspondence_params || {})
    @correspondence = Correspondence.new(session[:correspondence])
  end

  def suggested_values
    values = {
      day: Time.zone.today.day,
      month: Time.zone.today.month,
      year: Time.zone.today.year
    }

    reporter = @investigation.reporter
    if reporter
      values = values.merge(
        correspondent_name: reporter.name,
        contact_method: get_contact_method,
        phone_number: reporter.phone_number,
        email_address: reporter.email_address
      )
    end

    values
  end

  def get_contact_method
    reporter = @investigation.reporter
    if reporter.email_address.present?
      Correspondence.contact_methods[:email]
    elsif reporter.phone_number.present?
      Correspondence.contact_methods[:phone]
    end
  end

  def clear_session
    session[:correspondence] = nil
  end
end