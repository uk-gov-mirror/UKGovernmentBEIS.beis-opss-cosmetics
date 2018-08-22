module DocumentsHelper
  def associated_documents_path(parent)
    polymorphic_path([parent, :documents])
  end

  def associated_document_path(parent, document)
    associated_documents_path(parent) + "/" + document.id.to_s
  end

  def new_associated_document_path(parent)
    associated_documents_path(parent) + "/new"
  end

  def edit_associated_document_path(parent, document)
    associated_document_path(parent, document) + "/edit"
  end

  def document_filetype_label(document)
    case
    when document.audio?
      "Audio"
    when document.image?
      "Image"
    when document.video?
      "Video"
    when document.text?
      "Text"
    when document.content_type == "application/pdf"
      "PDF"
    when document.content_type == "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
      "Word"
    when document.content_type == "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
      "Excel"
    when document.content_type == "application/vnd.openxmlformats-officedocument.presentationml.presentation"
      "PowerPoint"
    when document_file_extension(document) != nil
      document_file_extension(document).upcase
    else
      "Other"
    end
  end

  def document_file_extension(document)
    File.extname(document.filename.to_s)&.remove(".").upcase
  end
end
