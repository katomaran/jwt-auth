class ApplicationController < ActionController::API
  before_action :authentication

  def authentication
    auth_header = request.headers['Authorization'].presence || (return unauthorized)
    _str, token = auth_header.split(' ')
    data = JwtHelper.verify_access_token(token: token)
    @current_user = User.find(data['id'])
  rescue => _e
    unauthorized
  end

  def unauthorized
    render json: { message: 'Unauthorized' }, status: :unauthorized
  end

  attr_reader :current_user
end
