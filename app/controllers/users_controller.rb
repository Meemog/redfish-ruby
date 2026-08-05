class UsersController < ApplicationController
  include Authenticatable
  include Authorizable

  skip_before_action :authenticate_request, only: [ :login, :refresh ]

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
      render json: create_auth_response(user)
    else
      render json: { error: "Invalid credentials" }, status: :unauthorized
    end
  end

  def refresh
    user = RefreshService.authenticate(params[:refresh])

    if user
      render json: create_auth_response(user)
    else
      render json: { error: "Invalid credentials" }, status: :unauthorized
    end
  end

  def logout
    @current_user.logout

    head :no_content
  end

  private

  def create_auth_response(user)
      user.refresh_tokens.destroy_all

      token, exp = JwtService.encode({ user_id: user.id })
      refresh_token, refresh_exp = RefreshService.generate(user)

      {
        issuedAt: Time.now,
        token: {
          token: token,
          expiresAt: exp
        },
        refresh: {
          token: refresh_token,
          expiresAt: refresh_exp
        }
      }
  end

  def user_params
    params.permit(
      :username,
      :password,
      :roleId
    )
  end
end
