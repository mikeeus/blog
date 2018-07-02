require "jwt"

class Auth::SignIn < ApiAction
  post "/auth/sign_in" do
    SignInForm.new(params).submit do |form, user|
      if user
        context.response.headers.add "Authorization", "Bearer #{token(user)}"
        head 200
      else
        pp form
        head 401
      end
    end
  end

  private def token(user : User)
    exp = Time.now.epoch + 60 * 60
    sub = ({ id: user.id, name: user.name, email: user.email }).to_s
    payload = {
      "sub" => Base64.encode(sub),
      "exp" => exp
    }

    JWT.encode(payload, Lucky::Server.settings.secret_key_base, "HS256")
  end
end
