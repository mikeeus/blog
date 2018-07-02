class Auth::SignUp < ApiAction
  post "/auth/sign_up" do
    SignUpForm.create(params) do |form, user|
      if user
        context.response.headers.add "Authorization", user.generate_token
        head 200
      else
        head 401
      end
    end
  end
end
