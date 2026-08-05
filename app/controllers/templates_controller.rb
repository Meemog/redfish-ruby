class TemplatesController < ApplicationController
  include Authenticatable
  include Authorizable

  before_action -> { require_permission("templates.read") },
                only: [ :index, :show ]

  before_action -> { require_permission("templates.write") },
                only: [ :create, :update, :destroy ]

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

    ActiveRecord::Base.transaction do
      template.save!

      Array(params[:paths]).each do |item|
        template.template_paths.create!(
          path: item[:path],
          name: item[:name]
        )
      end
    end

    render json: TemplateSerializer.call(template), status: :created
  rescue ActiveRecord::RecordInvalid => e
    render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
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
