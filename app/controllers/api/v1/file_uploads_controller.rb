# app/controllers/api/v1/file_uploads_controller.rb
module Api
  module V1
    class FileUploadsController < ApplicationController
      skip_before_action :verify_authenticity_token
      
      def create
        uploaded_file = UploadedFile.new(file: params[:file])

        if uploaded_file.save
          render json: 'File uploaded successfully'
        else
          render json: { error: 'Failed to upload file' }, status: :unprocessable_entity
        end
      end
    end
  end
end
