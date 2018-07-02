class Auth::SignIn < ApiAction
  include GenerateToken

  post "/auth/sign_in" do
    SignInForm.new(params).submit do |form, user|
      if user
        context.response.headers.add "Authorization", "Bearer #{generate_token(user)}"
        head 200
      else
        head 401
      end
    end
  end
end
