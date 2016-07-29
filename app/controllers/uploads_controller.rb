class UploadsController < ApplicationController
  before_action :signed_in?

  def upload
    data = params[:upload]
    File.open('public/images/' + data[:datafile].original_filename, 'wb') do |f|
      f.write(data[:datafile].read)
    end

    redirect_to :back
  end

  private
    def signed_in?
      if current_user == nil
        redirect_to login_path
      end
    end
end
