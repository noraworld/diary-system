# frozen_string_literal: true

class TemplatesController < ApplicationController
  before_action :signed_in?

  def index
    is_disabled = filter_template('availability', params[:availability])
    is_private  = filter_template('visibility',   params[:visibility])

    @templates = Template.where(is_disabled: is_disabled, is_private: is_private).order('position ASC')
  end

  def new
    @post_template_url = templates_new_path
    @template_form_title = 'Create a new template'
    @back_link_url = templates_index_path
  end

  def create
    @template = Template.new(template_params)
    @template_form_title = 'Create a new template'
    @template.uuid = SecureRandom.hex
    @template.position = Template.maximum(:position).to_i + 1

    if @template.save
      redirect_to templates_index_path(availability: 'all', visibility: 'all')
    else
      @post_template_url = templates_new_path
      @template_form_title = 'Create a new template'
      @back_link_url = templates_index_path

      flash.now[:alert] = 'Create failed...'
      render 'new'
    end
  end

  def edit
    @template = Template.find_by!(uuid: params[:uuid])
    @post_template_url = "/templates/#{params[:uuid]}"
    @template_form_title = 'Edit the template'
    @back_link_url = templates_index_path(availability: 'all', visibility: 'all')
  end

  def update
    @template = Template.find_by!(uuid: params[:uuid])
    @template_form_title = 'Edit the template'

    if @template.update(template_params)
      redirect_to templates_index_path(availability: 'all', visibility: 'all')
    else
      @post_template_url = "/templates/#{params[:uuid]}"
      @template_form_title = 'Edit the template'
      @back_link_url = templates_index_path(availability: 'all', visibility: 'all')

      flash.now[:alert] = 'Update failed...'
      render 'edit'
    end
  end

  def destroy
    if Rails.env.production?
      redirect_to templates_index_path, alert: 'Cannot delete a template in production!'
    else
      @template = Template.find_by!(uuid: params[:uuid])
      @template.destroy if Rails.env.development?

      redirect_to templates_index_path(availability: 'all', visibility: 'all')
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

  def filter_template(param_type, param_value)
    case param_type
    when 'availability'
      case param_value
      when 'enabled'
        # when availability is enabled, is_disabled is false
        false
      when 'disabled'
        # when availability is disable, is_disabled is true
        true
      when 'all'
        [true, false]
      else
        false
      end
    when 'visibility'
      case param_value
      when 'public'
        # when visibility is public, is_private is false
        false
      when 'private'
        # when visibility is private, is_private is true
        true
      when 'all'
        [true, false]
      else
        [true, false]
      end
    end
  end

  def template_params
    params.require(:template).permit(:title, :body, :position, :format, :is_private, :is_disabled, :placeholder)
  end

  def signed_in?
    redirect_to login_path if current_user.nil?
  end
end
