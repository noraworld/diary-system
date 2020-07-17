# frozen_string_literal: true

class SettingsController < ApplicationController
  before_action :signed_in?

  def edit
    @setting = Setting.first # it returns nil if Setting is empty
  end

  def update
    return create_new_settings if Setting.all.empty?

    @setting = Setting.first
    if @setting.update(setting_params)
      redirect_to '/settings'
    else
      flash.now[:alert] = 'Update failed...'
      render 'edit'
    end
  end

  private

  def create_new_settings
    @setting = Setting.new(setting_params)
    @setting.launched_since = Article.first.year

    if @setting.save
      redirect_to '/settings'
    else
      flash.now[:alert] = 'Create failed...'
      render 'edit'
    end
  end

  def setting_params
    params.require(:setting).permit(:site_title, :site_description, :host_name, :default_public_in, :ga_tracking_identifier, :time_zone)
  end

  def signed_in?
    redirect_to login_path if current_user.nil?
  end
end
