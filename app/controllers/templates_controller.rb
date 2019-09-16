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

  def sort
    from = params[:from].to_i - 1
    to   = params[:to].to_i   - 1

    templates = Template.all.order('position ASC')

    dest_template_position = templates[to].position
    templates[to].position = 0
    templates[to].save

    src_template_position = templates[from].position
    templates[from].position = dest_template_position
    templates[from].save

    current_template_position = nil
    stored_template_position = nil

    if from < to
      (from + 1).upto(to) do |num|
        current_template_position = templates[num].position

        if stored_template_position.present?
          templates[num].position = stored_template_position
        else
          templates[num].position = src_template_position
        end

        stored_template_position = current_template_position

        templates[num].save
      end
    elsif from > to
      (from - 1).downto(to) do |num|
        current_template_position = templates[num].position

        if stored_template_position.present?
          templates[num].position = stored_template_position
        else
          templates[num].position = src_template_position
        end

        stored_template_position = current_template_position

        templates[num].save
      end
    end

    render body: "from: #{params[:from]}, to: #{params[:to]}", status: :ok
  end

  private

  def template_params
    params.require(:template).permit(:title, :body, :position)
  end

  def signed_in?
    redirect_to login_path if current_user.nil?
  end
end
