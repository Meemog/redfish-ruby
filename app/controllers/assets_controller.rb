require "json"

class AssetsController < ApplicationController
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
      asset.json_histories
          .order(UploadDate: :desc)
          .offset(index)
          .first

    render json: AssetSerializer.new(asset, history).as_json
  end

  def create
    asset = Asset.new(
      RackId: params[:rackId],
      Name: params[:name],
      Size: params[:size],
      Position: params[:position]
    )

    ActiveRecord::Base.transaction do
      asset.save!

      params[:data].each do |item|
        asset.paths.create!(
          Path: item[:path],
          Name: item[:name]
        )
      end

      asset.json_histories.create!(
        RawJson: params[:json][:text],
        Filename: params[:json][:filename],
        UploadDate: Time.now
      )
    end

    render json: serialize_asset(asset),
          status: :created
  end

  def create_json
    asset = Asset.find(params[:id])

    history = asset.json_histories.create!(
      RawJson: params[:json][:text],
      Filename: params[:json][:filename],
      UploadDate: Time.now
    )

    render json: serialize_asset(asset)
  end

  def update
    asset = Asset.find(params[:id])

    ActiveRecord::Base.transaction do
      asset.update!(asset_update_params)
    end

    render json: serialize_asset(asset)
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
    ).to_h.transform_keys do |key|
      {
        "rackId" => "RackId",
        "name" => "Name",
        "size" => "Size",
        "position" => "Position"
      }[key]
    end.compact
  end
end
