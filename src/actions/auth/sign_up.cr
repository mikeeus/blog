class Auth::SignUp < ApiAction
  # NOTE: This endpoint should not be implemented
  post "/auth/sign_up" do
    head 401
    # SignUpForm.create(params) do |form, user|
    #   if user
    #     context.response.headers.add "Authorization", user.generate_token
    #     head 200
    #   else
    #     head 401
    #   end
    # end
  end
end
