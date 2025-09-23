class Api::V1::AuthController < ApplicationController
  def register
    user = User.new(user_params)

    if user.save
      token = JwtService.encode(user_id: user.id)
      render json: {
        data: {
          id: user.id,
          type: "user",
          attributes: {
            name: user.name,
            email: user.email
          }
        },
        meta: {
          token: token
        }
      }, status: :created
    else
      render json: {
        errors: user.errors.full_messages.map do |message|
          {
            status: "422",
            title: "Validation Error",
            detail: message
          }
        end
      }, status: :unprocessable_entity
    end
  end

  def login
    user = User.find_by(email: login_params[:email])

    if user&.authenticate(login_params[:password])
      token = JwtService.encode(user_id: user.id)
      render json: {
        data: {
          id: user.id,
          type: "user",
          attributes: {
            name: user.name,
            email: user.email
          }
        },
        meta: {
          token: token
        }
      }
    else
      render json: {
        errors: [
          {
            status: "401",
            title: "Unauthorized",
            detail: "Invalid email or password"
          }
        ]
      }, status: :unauthorized
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def login_params
    params.require(:user).permit(:email, :password)
  end
end
