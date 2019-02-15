class ResponsiblePersons::TeamMembersController < ApplicationController
  before_action :set_responsible_person

private

  def set_responsible_person
    @responsible_person = ResponsiblePerson.find(params[:responsible_person_id])
    authorize @responsible_person, :show?
  end
end