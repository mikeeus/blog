require "jwt"

class User < BaseModel
  include Carbon::Emailable
  include Authentic::PasswordAuthenticatable

  table :users do
    column name : String
    column email : String
    column encrypted_password : String
  end

  def emailable
    Carbon::Address.new(email)
  end

  def generate_token
    exp = Time.now.epoch + 60 * 60 * 24 * 14
    user = ({ id: id, name: name, email: email }).to_s
    payload = { "sub" => id, "user" => Base64.encode(user), "exp" => exp }

    JWT.encode(payload, Lucky::Server.settings.secret_key_base, "HS256")
  end
end
