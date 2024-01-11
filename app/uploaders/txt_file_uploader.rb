# app/uploaders/txt_file_uploader.rb
class TxtFileUploader < CarrierWave::Uploader::Base
  storage :file

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def filename
    original_filename if original_filename
  end

  def extension_whitelist
    %w(txt)
  end
end
