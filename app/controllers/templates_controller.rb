# frozen_string_literal: true

class TemplatesController < ApplicationController
  before_action :signed_in?

  def index
    @templates = Template.all.order('sort ASC')
  end

  def new
    @template = Template.new
    @post_template_url = '/templates/new'
  end

  def create
    @template = Template.new(template_params)

    if @template.save
      redirect_to '/templates'
    else
      render 'new'
    end
  end

  def edit
    @template = Template.find_by!(name: params[:name])
    @post_template_url = "/templates/#{params[:name]}"
  end

  def update
    @template = Template.find_by!(name: params[:name])

    if @template.update(template_params)
      redirect_to "/templates"
    else
      render 'edit'
    end
  end

  def destroy
    @template = Template.find_by!(name: params[:name])
    @template.destroy

    redirect_to "/templates"
  end

  private

  def template_params
    params.require(:template).permit(:name, :title, :body, :sort)
  end

  def signed_in?
    redirect_to login_path if current_user.nil?
  end
end
