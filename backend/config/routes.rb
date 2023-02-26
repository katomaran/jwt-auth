Rails.application.routes.draw do
  post :signup, to: 'authentication#signup'
  post :login, to: 'authentication#login'
  get :protected_route, to: 'authentication#protected_route'

  post :refresh_token, to: 'authentication#refresh_token'
  delete :logout, to: 'authentication#logout'
end
