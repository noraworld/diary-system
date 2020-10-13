# frozen_string_literal: true

class UploadsController < ApplicationController
  before_action :signed_in?

  require 'filemagic'
  require 'RMagick'

  include ArticlesHelper

  RANDOMIZED_HEXADECIMAL_LENGTH = 64

  def upload
    # dropzone.jsで使用するパラメータと一致していないといけない
    data  = params[:data]
    year  = adjusted_current_time.strftime('%Y').to_s
    month = adjusted_current_time.strftime('%m').to_s
    path  = 'public/images/' + year + '/' + month + '/'

    # public/images/year/month ディレクトリがなければ作成する
    FileUtils.mkdir_p(path) unless FileTest.exist?(path)

    content = data[:file].read

    # 画像ファイルじゃない場合はアップロードしない
    fm = FileMagic.new
    unless /^(PNG|JPEG|GIF) /.match?(fm.buffer(content))
      render body: nil, status: :not_acceptable
      return
    end

    # RMagickをバイナリから読み取る
    img = Magick::Image.from_blob(content).shift
    # 画像が大きい場合はリサイズする
    img = img.resize_to_fit(800, 1200) if img.columns > 800
    # スマホでアップロードされた画像がパソコンで横向き表示にならないようにする
    img.auto_orient!
    # 画像ファイルをアップロードする
    img.write(path + data[:file].original_filename)

    render body: nil, status: :ok
  end

  def s3
    # TODO: implement validation with form object
    file_extension = params[:filename].match(/(.*)(?:\.([^.]+$))/)[2].downcase
    mimetype = params[:mimetype]

    presigned_object = S3_BUCKET.presigned_post(
      key: "images/#{adjusted_current_time.to_date.year}/#{adjusted_current_time.to_date.month}/#{SecureRandom.hex(RANDOMIZED_HEXADECIMAL_LENGTH / 2)}.#{file_extension}",
      content_type: mimetype,
      success_action_status: '201',
      acl: 'public-read'
    )

    render json: { url: presigned_object.url, fields: presigned_object.fields, s3_url: s3_url(presigned_object.fields['key']) }
  end

  private

  def s3_url(path)
    url_scheme = ENV.fetch('S3_ENABLED') ? 'https' : 'http'
    "#{url_scheme}://#{ENV.fetch('S3_BUCKET')}/#{path}"
  end

  def signed_in?
    redirect_to login_path if current_user.nil?
  end
end
