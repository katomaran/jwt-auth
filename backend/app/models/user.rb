class User < ApplicationRecord
  before_create do
    self.password = Digest::SHA1.hexdigest(password)
  end

  def access_token
    payload = {
      id: id,
      email: email
    }
    JwtHelper.sign_access_token(payload)
  end

  def refresh_token
    payload = {
      id: id,
      email: email
    }
    token = JwtHelper.sign_refresh_token(payload)
    REDIS.set(id, token)
    token
  end
end
