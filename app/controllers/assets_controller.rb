class AssetsController < ApplicationController
  def index
    render json: Asset.all.map { |asset| serialize_asset(asset) }
  end


  def show
    asset = Asset.find(params[:id])

    render json: serialize_asset(asset)
  end


  def history
    asset = Asset.find(params[:id])

    index = params[:index].to_i

    history =
      asset.json_histories
           .order(UploadDate: :desc)
           .offset(index)
           .first

    render json: serialize_asset(asset, history)
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
        RawJson: params[:json],
        UploadDate: Time.now
      )
    end

    render json: serialize_asset(asset),
          status: :created
  end

  def create_json
    asset = Asset.find(params[:id])

    history = asset.json_histories.create!(
      RawJson: params[:json],
      UploadDate: Time.now
    )

    render json: serialize_asset(asset)
  end

  def update
    asset = Asset.find(params[:id])

    ActiveRecord::Base.transaction do
      asset.update!(asset_update_params)

      if params[:data]
        asset.paths.destroy_all

        params[:data].each do |item|
          asset.paths.create!(
            Path: item[:path],
            Name: item[:name]
          )
        end
      end
    end

    render json: serialize_asset(asset)
  end

  def destroy
    asset = Asset.find(params[:id])

    asset.destroy

    head :no_content
  end


  private


  def serialize_asset(asset, json_history = nil)
    json_history ||= asset.latest_json

    {
      id: asset.ID,
      rackId: asset.RackId,
      name: asset.Name,
      size: asset.Size,
      position: asset.Position,

      data: asset.paths.map do |path|
        {
          path: path.Path,
          name: path.Name,
          value: extract_value(path)
        }
      end,

      json: json_history&.RawJson,

      pagination: {
        position: json_history_position(asset, json_history),
        total: asset.json_histories.count
      }
    }
  end

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


  def json_history_position(asset, history)
    return 0 unless history

    asset.json_histories
         .order(UploadDate: :desc)
         .pluck(:ID)
         .index(history.ID)
  end


  def extract_value(path)
    "CHANGE THIS"
  end
end
