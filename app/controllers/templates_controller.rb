# frozen_string_literal: true

class TemplatesController < ApplicationController
  before_action :signed_in?

  def index
    @templates = Template.all.order('position ASC')
  end

  def new
    @post_template_url = '/templates/new'
  end

  def create
    @template = Template.new(template_params)
    @template.uuid = SecureRandom.hex

    if @template.save
      redirect_to '/templates'
    else
      render 'new'
    end
  end

  def edit
    @template = Template.find_by!(uuid: params[:uuid])
    @post_template_url = "/templates/#{params[:uuid]}"
  end

  def update
    @template = Template.find_by!(uuid: params[:uuid])

    if @template.update(template_params)
      redirect_to "/templates"
    else
      render 'edit'
    end
  end

  def destroy
    @template = Template.find_by!(uuid: params[:uuid])
    @template.destroy

    redirect_to "/templates"
  end

  private

  def template_params
    params.require(:template).permit(:title, :body, :position)
  end

  def signed_in?
    redirect_to login_path if current_user.nil?
  end
end
