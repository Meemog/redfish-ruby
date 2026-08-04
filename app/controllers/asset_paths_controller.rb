class PathsController < ApplicationController
  include Authenticatable
  include Authorizable

  before_action -> { require_permission("paths.read") },
                only: [ :index, :show ]

  before_action -> { require_permission("paths.write") },
                only: [ :create, :update, :destroy ]

  before_action :set_asset
  before_action :set_path, only: [ :show, :update, :destroy ]

  def index
    render json: @asset.asset_paths
  end

  def show
    render json: @path
  end

  def create
    paths = paths_params.map do |attrs|
      @asset.asset_paths.build(attrs)
    end

    if paths.all?(&:save)
      render json: paths, status: :created
    else
      errors = paths.filter_map do |path|
        {
          attributes: path.attributes,
          errors: path.errors.full_messages
        } unless path.persisted?
      end

      render json: { errors: errors }, status: :unprocessable_entity
    end
  end

  def update
    if @path.update(path_params)
      render json: @path
    else
      render json: @path.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @path.destroy
    head :no_content
  end

  private


  def set_asset
    @asset = Asset.find(params[:asset_id])
  end

  def set_path
    @path = @asset.asset_paths.find(params[:id])
  end

  def path_params
    params.permit(:path, :name)
  end

  def paths_params
    params.require(:paths).map do |path|
      path.permit(:path, :name)
    end
  end
end
