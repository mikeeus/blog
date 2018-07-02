abstract class AuthenticatedAction < Lucky::Action
  before require_current_user

  getter current_user : User? = nil
  
  private def require_current_user
    token = context.request.headers["Authorization"]?

    if token.nil?
      head 401
    else
      @current_user = UserQuery.new.from_token(token)
    end

    if @current_user.nil?
      head 401
    else
      continue
    end

  rescue JWT::ExpiredSignatureError
    head 401
  end
end