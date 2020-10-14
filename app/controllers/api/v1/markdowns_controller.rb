# frozen_string_literal: true

class Api::V1::MarkdownsController < ApplicationController
  before_action :signed_in?

  include ApplicationHelper

  def markdown
    render json: { markdown: qiita_markdown(params[:body]) }
  end

  private

  def signed_in?
    redirect_to login_path if current_user.nil?
  end
end
