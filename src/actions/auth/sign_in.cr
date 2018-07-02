class Auth::SignIn < ApiAction
  post "/auth/sign_in" do
    SignInForm.new(params).submit do |form, user|
      if user
        context.response.headers.add "Authorization", user.generate_token
        head 200
      else
        head 401
      end
    end
  end
end
