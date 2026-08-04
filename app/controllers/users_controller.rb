class UsersController < ApplicationController
  include Authenticatable
  include Authorizable

  skip_before_action :authenticate_request, only: [ :login ]

  before_action -> { require_permission("users.write") },
                only: [ :create, :destroy ]

  def create
    user = User.new(user_params.except(:password))
    user.passwordHash = Hasher.call(params[:password])

    if user.save
      head :created
    else
      render json: user.errors, status: :unprocessable_entity
    end
  end

  def destroy
    user = User.find(params[:id])

    user.destroy

    head :no_content
  end

  def login
    user = User.find_by(username: params[:username])

    if user&.authenticate(params[:password])
      token = JwtService.encode({ user_id: user.id })

      render json: {
        token: token,
        user: {
          id: user.id,
          username: user.username
        }
      }
    else
      render json: { error: "Invalid credentials" }, status: :unauthorized
    end
  end

  private

  def user_params
    params.permit(
      :username,
      :password,
      :roleId
    )
  end
end
