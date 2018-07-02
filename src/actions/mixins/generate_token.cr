require "jwt"

module GenerateToken
  private def generate_token(user : User)
    exp = Time.now.epoch + 60 * 60
    sub = ({ id: user.id, name: user.name, email: user.email }).to_s
    payload = { "sub" => Base64.encode(sub), "exp" => exp }

    JWT.encode(payload, Lucky::Server.settings.secret_key_base, "HS256")
  end
end