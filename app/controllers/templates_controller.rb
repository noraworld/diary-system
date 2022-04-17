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

    if from < to
      sort_up_to_down(templates, from, to)
    elsif from > to
      sort_down_to_up(templates, from, to)
    end

    render body: "from: #{params[:from]}, to: #{params[:to]}", status: :ok
  end

  private

  def sort_up_to_down(templates, from, to)
    swap_src_and_dest(templates, from, to)

    current_template_position = nil
    stored_template_position = nil

    (from + 1).upto(to) do |num|
      current_template_position, stored_template_position =
        shift_position(templates, current_template_position, stored_template_position)
    end
  end

  def sort_down_to_up(templates, from, to)
    swap_src_and_dest(templates, from, to)

    current_template_position = nil
    stored_template_position = nil

    (from - 1).downto(to) do |num|
      current_template_position, stored_template_position =
        shift_position(templates, current_template_position, stored_template_position)
    end
  end

  def swap_src_and_dest(templates, from, to)
    dest_template_position = templates[to].position
    templates[to].position = 0
    templates[to].save

    src_template_position = templates[from].position
    templates[from].position = dest_template_position
    templates[from].save
  end

  def shift_position(templates, current_template_position = nil, stored_template_position = nil)
    current_template_position = templates[num].position

    if stored_template_position.present?
      templates[num].position = stored_template_position
    else
      templates[num].position = src_template_position
    end

    stored_template_position = current_template_position

    templates[num].save

    return current_template_position, stored_template_position
  end

  def template_params
    params.require(:template).permit(:title, :body, :position, :format, :is_private, :is_disabled, :placeholder)
  end

  def signed_in?
    redirect_to login_path if current_user.nil?
  end
end
