class TemplatesController < ApplicationController
  before_action :set_template, only: [ :show, :update, :destroy ]
  def index
    render json: Template.all.map { |template|
      TemplateSerializer.call(template)
    }
  end

  def show
    render json: TemplateSerializer.call(@template)
  end

  def create
    template = Template.new(template_params)

    if template.save
      render json: TemplateSerializer.call(template), status: :created
    else
      render json: template.errors, status: :unprocessable_entity
    end
  end

  def update
    if @template.update(template_params)
      render json: TemplateSerializer.call(@template), status: :created
    else
      render json: @template.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @template.destroy
  end

  private

  def set_template
    @template = Template.find(params[:id])
  end

  def template_params
    params.permit(:name)
  end
end
