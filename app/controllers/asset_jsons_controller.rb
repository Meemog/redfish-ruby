class AssetJsonsController < ApplicationController
  include Authenticatable
  include Authorizable

  before_action -> { require_permission("history.read") },
                only: [ :index, :show ]

  before_action -> { require_permission("history.write") },
                only: [ :destroy ]

  def index
    histories = AssetJson.where(assetId: params[:id])

    render json: HistorySerializer.collection(histories)
  end

  def show
    history = AssetJson.find_by(
      assetId: params[:id],
      id: params[:history_id]
    )

    render json: HistorySerializer.call(history)
  end

  def destroy
    history = AssetJson.find_by(
      assetId: params[:id],
      id: params[:history_id]
    )

    if history
      history.destroy
      head :no_content
    else
      head :not_found
    end
  end
end
