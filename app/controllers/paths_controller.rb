class PathsController < ApplicationController
  before_action :set_asset
  before_action :set_path, only: [ :show, :update, :destroy ]

  def index
    render json: @asset.paths
  end

  def show
    render json: @path
  end

  def create
    path = @asset.paths.build(path_params)

    if path.save
      render json: path, status: :created
    else
      render json: path.errors, status: :unprocessable_entity
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
    @path = @asset.paths.find(params[:id])
  end

  def path_params
    params.permit(:path, :name).transform_keys do |key|
      key.to_s.capitalize
    end
  end
end
