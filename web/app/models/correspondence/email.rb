class Correspondence::Email < Correspondence
  has_one_attached :email_file
  has_one_attached :email_attachment

  enum email_direction: {
      outbound: "To",
      inbound: "From"
  }

  def validate_email_file_and_content file_blob
    if file_blob.nil? && email_subject.empty? && details.empty?
      errors.add(:email, "- please provide either an email file or a subject and body")
    end
  end
end