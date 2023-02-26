## app/controllers/authentication_controller.rb

class AuthenticationController < ApplicationController
  skip_before_action :authentication, only: %i[signup login]

  def signup
    user = User.find_by(email: params[:email])
    if user
      render json: { message: 'Email already registered' }
      return
    end

    user = User.create!(email: params[:email], name: params[:name], password: params[:password])

    render json: {
      message: 'User registration successful',
      data: user.as_json(only: %i[id email name], methods: %i[access_token refresh_token])
    }, status: :created
  end

  def login
    user = User.find_by(email: params[:email], password: Digest::SHA1.hexdigest(params[:password]))
    unless user
      render json: { message: 'Invalid email or password' }, status: :unauthorized
      return
    end

    user.update!(last_login_at: Time.now)
    render json: {
      message: 'User login successful',
      data: user.as_json(only: %i[id email name], methods: %i[access_token refresh_token])
    }
  end

  def logout
    REDIS.del(current_user.id) if current_user

    render json: { message: 'Log out successful' }
  end

  def refresh_token
    payload = JwtHelper.verify_refresh_token(token: params[:refresh_token])

    raise StandardError unless REDIS.get(payload['id']) == params[:refresh_token]

    user = User.find(payload['id'])

    render json: {
      message: 'Token refresh successful',
      data: user.as_json(only: [], methods: %i[access_token refresh_token])
    }
  rescue => _e
    render json: {message: 'Invalid Refresh token'}, status: :forbidden
  end

  def protected_route
    render json: {
      message: "Hello #{current_user.name}, we have implemented JWT authentication"
    }
  end
end
