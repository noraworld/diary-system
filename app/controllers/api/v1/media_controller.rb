# frozen_string_literal: true

class Api::V1::MediaController < ApplicationController
  before_action :signed_in?

  require 'filemagic'
  require 'RMagick'

  include ApplicationHelper
  include ArticlesHelper

  RANDOMIZED_HEXADECIMAL_LENGTH = 64

  def show
    # TODO: implement validation with form object
    file_extension = params[:filename].match(/(.*)(?:\.([^.]+$))/)[2].downcase
    mimetype = params[:mimetype]
    path = media_path(file_extension)

    case file_storage
    when 's3'
      presigned_object = S3_BUCKET.presigned_post(
        key: path,
        content_type: mimetype,
        success_action_status: '201',
        acl: 'public-read'
      )

      render json: {
        file_storage: file_storage,
        dest_domain:  presigned_object.url,
        media_url:    s3_url(presigned_object.fields['key']),
        fields:       presigned_object.fields
      }
    when 'local'
      render json: {
        file_storage: file_storage,
        dest_domain:  api_v1_media_post_path,
        media_url:    "/#{path}",
        fields: {
          key: path,
          'Content-Type': mimetype
        }
      }
    end
  end

  def create
    year  = adjusted_current_time.strftime('%Y').to_s
    month = adjusted_current_time.strftime('%m').to_s
    path  = 'public/images/' + year + '/' + month + '/'
    FileUtils.mkdir_p(path) unless FileTest.exist?(path)

    content = params[:file].read

    fm = FileMagic.new
    unless /^(PNG|JPEG|GIF) /.match?(fm.buffer(content))
      render body: nil, status: :not_acceptable
      return
    end

    img = Magick::Image.from_blob(content).shift
    img.auto_orient!
    img.write("public/#{params[:key]}")

    render body: nil, status: :ok
  end

  private

  def s3_url(path)
    "#{ENV.fetch('S3_PROTOCOL')}://#{ENV.fetch('S3_BUCKET')}/#{path}"
  end

  def media_path(file_extension)
    "images/#{adjusted_current_time.to_date.year}/#{adjusted_current_time.to_date.month}/#{SecureRandom.hex(RANDOMIZED_HEXADECIMAL_LENGTH / 2)}.#{file_extension}"
  end

  def signed_in?
    redirect_to login_path if current_user.nil?
  end
end
