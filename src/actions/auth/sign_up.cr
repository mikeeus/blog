class Auth::SignUp < ApiAction
  include GenerateToken

  post "/auth/sign_up" do
    SignUpForm.create(params) do |form, user|
      if user
        context.response.headers.add "Authorization", "Bearer #{generate_token(user)}"
        head 200
      else
        head 401
      end
    end
  end
end
