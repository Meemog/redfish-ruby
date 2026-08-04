module Authenticatable
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_request
  end

  private

  def authenticate_request
    token = request.headers["Authorization"]&.split(" ")&.last

    payload = JwtService.decode(token)

    if payload
      @current_user = User.find_by(id: payload[:user_id])
    end

    return if @current_user

    render json: { error: "Unauthorized" }, status: :unauthorized
  end

  def current_user
    @current_user
  end
end
