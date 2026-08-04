class RacksController < ApplicationController
  include Authenticatable
  include Authorizable

  before_action -> { require_permission("racks.read") },
                only: [ :index, :show ]

  before_action -> { require_permission("racks.write") },
                only: [ :create, :update, :destroy ]

  def index
    render json: RackRecord.all.map { |rack| serialize_rack(rack) }
  end

  def show
    rack = RackRecord.find(params[:id])

    render json: serialize_rack(rack)
  end


  def create
    rack = RackRecord.new(rack_params)

    if rack.save
      render json: serialize_rack(rack), status: :created
    else
      render json: rack.errors, status: :unprocessable_entity
    end
  end


  def update
    rack = RackRecord.find(params[:id])

    if rack.update(rack_params)
      render json: serialize_rack(rack)
    else
      render json: rack.errors, status: :unprocessable_entity
    end
  end


  def destroy
    rack = RackRecord.find(params[:id])

    rack.destroy

    head :no_content
  end

  def all_assets
    rack = RackRecord.find(params[:id])

    render json: rack.assets.map { |asset| AssetSerializer.new(asset).as_json }
  end


  private


  def rack_params
    params.permit(:name, :size, :notes)
  end


  def serialize_rack(rack)
    {
      id: rack.id,
      name: rack.name,
      size: rack.size,
      notes: rack.notes
    }
  end
end
