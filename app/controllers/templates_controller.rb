# frozen_string_literal: true

class TemplatesController < ApplicationController
  before_action :signed_in?

  def index
    @templates = Template.all.order('position ASC')
  end

  def new
    @post_template_url = '/templates/new'
    @template_form_title = 'Create a new template'
    @back_link_url = templates_index_path
  end

  def create
    @template = Template.new(template_params)
    @template_form_title = 'Create a new template'
    @template.uuid = SecureRandom.hex
    @template.position = Template.maximum(:position) + 1

    if @template.save
      redirect_to '/templates'
    else
      @post_template_url = '/templates/new'
      @template_form_title = 'Create a new template'
      @back_link_url = templates_index_path

      render 'new'
    end
  end

  def edit
    @template = Template.find_by!(uuid: params[:uuid])
    @post_template_url = "/templates/#{params[:uuid]}"
    @template_form_title = 'Edit the template'
    @back_link_url = templates_index_path
  end

  def update
    @template = Template.find_by!(uuid: params[:uuid])
    @template_form_title = 'Edit the template'

    if @template.update(template_params)
      redirect_to "/templates"
    else
      @post_template_url = "/templates/#{params[:uuid]}"
      @template_form_title = 'Edit the template'
      @back_link_url = templates_index_path

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
