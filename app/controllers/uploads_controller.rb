class UploadsController < ApplicationController
  before_action :signed_in?

  require 'filemagic'
  require 'RMagick'

  def upload
    # dropzone.jsで使用するパラメータと一致していないといけない
    data  = params[:data]
    year  = (Time.now.in_time_zone('Tokyo') - 3600 * 5).strftime('%Y').to_s
    month = (Time.now.in_time_zone('Tokyo') - 3600 * 5).strftime('%m').to_s
    path  = 'public/images/' + year + '/' + month + '/'

    # public/images/year/month ディレクトリがなければ作成する
    FileUtils.mkdir_p(path) unless FileTest.exist?(path)

    content = data[:file].read

    # 画像ファイルじゃない場合はアップロードしない
    fm = FileMagic.new()
    unless fm.buffer(content) =~ /^(PNG|JPEG|GIF) /
      render :body => nil, :status => 406
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

    render :body => nil, :status => 200
  end

  private
    def signed_in?
      if current_user == nil
        redirect_to login_path
      end
    end
end
