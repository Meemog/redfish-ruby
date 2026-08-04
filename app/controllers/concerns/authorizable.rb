module Authorizable
  extend ActiveSupport::Concern

  private

  def require_permission(permission)
    unless current_user&.can?(permission)
      render json: { error: "Forbidden" }, status: :forbidden
    end
  end
end
