class UploadsController < ApplicationController
  before_action :signed_in?

  require 'filemagic'

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
      render :nothing => true, :status => 406
      return
    end

    # 画像ファイルをアップロードする
    File.open(path + data[:file].original_filename, 'wb') do |f|
      f.write(content)
    end

    render :nothing => true, :status => 200
  end

  private
    def signed_in?
      if current_user == nil
        redirect_to login_path
      end
    end
end
