class RacksController < ApplicationController
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


  private


  def rack_params
    params.permit(
      :Name,
      :Size,
      :Notes
    )
  end


  def serialize_rack(rack)
    {
      id: rack.ID,
      name: rack.Name,
      size: rack.Size,
      notes: rack.Notes
    }
  end
end
