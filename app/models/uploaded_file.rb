# app/models/uploaded_file.rb
class UploadedFile < ApplicationRecord
    mount_uploader :file, TxtFileUploader
  end
  