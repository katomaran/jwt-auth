## app/helpers/jwt_helper.rb

class JwtHelper
    def self.sign_access_token(payload)
      JWT.encode(
        {
          data: payload,
          exp: exp_short,
          iss: 'auth-server', ## Needs to be your signing application
          aud: 'api-server', ## Needs to be your recipient application
          iat: iat,
        },
        access_secret,
      )
    end
  
    def self.verify_access_token(token:, aud: 'api-server', iss: 'auth-server', validate: true)
      JWT.decode(
        token, access_secret, validate,
        {
          iss: iss,
          aud: aud,
          verify_aud: true,
          verify_iss: false,
        }
      ).dig(0, 'data')
    end
  
    def self.sign_refresh_token(payload)
      JWT.encode(
        {
          data: payload,
          exp: exp_long,
          iss: 'auth-server', ## Needs to be your signing application
          aud: 'auth-server', ## Needs to be your signing application
          iat: iat,
        },
        refresh_secret,
      )
    end
  
    def self.verify_refresh_token(token:, aud: 'auth-server', iss: 'auth-server', validate: true)
      JWT.decode(
        token, refresh_secret, validate,
        {
          iss: iss,
          aud: aud,
          verify_aud: true,
          verify_iss: false,
        }
      ).dig(0, 'data')
    end
  
    def self.access_secret
      ENV.fetch('JWT_ACCESS_SECRET')
    end
  
    def self.refresh_secret
      ENV.fetch('JWT_REFRESH_SECRET')
    end
  
    def self.iat
      Time.now.to_i
    end
  
    def self.exp_short
      Time.now.to_i + 15.minute.to_i
    end
  
    def self.exp_long
      Time.now.to_i + 7.days.to_i
    end
  
    private_class_method :iat, :exp_short, :exp_long, :access_secret, :refresh_secret
  
  end