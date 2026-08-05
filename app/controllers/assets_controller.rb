require "json"

class AssetsController < ApplicationController
  include Authenticatable
  include Authorizable

  before_action -> { require_permission("assets.read") },
                only: [ :index, :show ]

  before_action -> { require_permission("assets.write") },
                only: [ :create, :update, :destroy ]

  def index
    render json: Asset.all.map { |asset| AssetSerializer.new(asset).as_json }
  end


  def show
    asset = Asset.find(params[:id])

    render json: AssetSerializer.new(asset).as_json
  end


  def history
    asset = Asset.find(params[:id])

    index = params[:index].to_i

    history =
      asset.asset_jsons
          .order(uploadDate: :desc)
          .offset(index)
          .first

    render json: AssetSerializer.new(asset, history).as_json
  end

  def create
    asset = nil

    ActiveRecord::Base.transaction do
      asset = Asset.create!(
        rackId: params[:rackId],
        name: params[:name],
        size: params[:size],
        position: params[:position]
      )

      params[:paths].each do |item|
        asset.asset_paths.create!(
          path: item[:path],
          name: item[:name]
        )
      end

      asset.asset_jsons.create!(
        rawJson: params[:json][:text],
        filename: params[:json][:filename],
        uploadDate: Time.current
      )
    end

    render json: AssetSerializer.new(asset).as_json,
          status: :created
  end

  def create_json
    asset = Asset.find(params[:id])

    history = asset.asset_jsons.create!(
      rawJson: params[:json][:text],
      filename: params[:json][:filename],
      uploadDate: Time.now
    )

    render json: AssetSerializer.new(asset, history).as_json
  end

  def update
    asset = Asset.find(params[:id])

    ActiveRecord::Base.transaction do
      asset.update!(asset_update_params)
    end

    render json: AssetSerializer.new(asset).as_json
  end

  def destroy
    asset = Asset.find(params[:id])

    asset.destroy

    head :no_content
  end


  private


  def asset_update_params
    params.permit(
      :rackId,
      :name,
      :size,
      :position
    )
  end
end
