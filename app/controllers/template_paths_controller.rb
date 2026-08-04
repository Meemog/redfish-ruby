class TemplatePathsController < ApplicationController
  include Authenticatable
  include Authorizable

  before_action -> { require_permission("template_paths.read") },
                only: [ :index, :show ]

  before_action -> { require_permission("template_paths.write") },
                only: [ :create, :update, :destroy ]

  before_action :set_template
  before_action :set_template_path, only: [ :show, :update, :destroy ]

  def index
    render json: @template.template_paths.map { |path|
      TemplatePathSerializer.call(path)
    }
  end

  def show
    render json: TemplatePathSerializer.call(@template_path)
  end

  def create
    template_path = @template.template_paths.new(template_path_params)

    if template_path.save
      render json: TemplatePathSerializer.call(template_path), status: :created
    else
      render json: template_path.errors, status: :unprocessable_entity
    end
  end

  def update
    if @template_path.update(template_path_params)
      render json: TemplatePathSerializer.call(@template_path)
    else
      render json: @template_path.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @template_path.destroy
    head :no_content
  end

  private

  def set_template
    @template = Template.find(params[:template_id])
  end

  def set_template_path
    @template_path = @template.template_paths.find(params[:id])
  end

  def template_path_params
    params.permit(:path, :name)
  end
end
