class JsonHistoriesController < ApplicationController
  def index
    histories = JsonHistory.where(AssetId: params[:id])

    render json: HistorySerializer.collection(histories)
  end

  def show
    history = JsonHistory.find_by(
      AssetId: params[:id],
      id: params[:history_id]
    )

    render json: HistorySerializer.call(history)
  end

  def destroy
    history = JsonHistory.find_by(
      AssetId: params[:id],
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
