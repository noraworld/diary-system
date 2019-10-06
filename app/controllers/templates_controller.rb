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
      redirect_to '/templates'
    else
      @post_template_url = "/templates/#{params[:uuid]}"
      @template_form_title = 'Edit the template'
      @back_link_url = templates_index_path

      render 'edit'
    end
  end

  def destroy
    if Rails.env.production?
      redirect_to templates_index_path, alert: 'Cannot delete a template in production!'
    else
      @template = Template.find_by!(uuid: params[:uuid])
      @template.destroy if Rails.env.development?

      redirect_to templates_index_path
    end
  end

  def sort
    from = params[:from].to_i
    to   = params[:to].to_i

    error_flag = false
    ActiveRecord::Base.transaction do
      templates = Template.all.order('position ASC')

      dest_template_position = templates[to].position
      templates[to].position = 0
      templates[to].save!

      src_template_position = templates[from].position
      templates[from].position = dest_template_position
      templates[from].save!

      current_template_position = nil
      stored_template_position = nil

      if from < to
        (from + 1).upto(to) do |num|
          current_template_position = templates[num].position
          templates[num].position = stored_template_position || src_template_position
          stored_template_position = current_template_position

          templates[num].save!
        end
      elsif from > to
        (from - 1).downto(to) do |num|
          current_template_position = templates[num].position
          templates[num].position = stored_template_position || src_template_position
          stored_template_position = current_template_position

          templates[num].save!
        end
      end

      unless Template.where(position: 0).count.zero?
        error_flag = true
        raise ActiveRecord::Rollback
      end
    end

    if error_flag
      render body: nil, status: :internal_server_error
    else
      render body: nil, status: :ok
    end
  end

  private

  def template_params
    params.require(:template).permit(:title, :body, :position, :format)
  end

  def signed_in?
    redirect_to login_path if current_user.nil?
  end
end
