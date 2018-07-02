class UserQuery < User::BaseQuery

  def from_token_payload(payload)
    find(payload["sub"].to_s)
  end

  def from_token(token : String)
    payload, _header = JWT.decode(token, Lucky::Server.settings.secret_key_base, "HS256")
    from_token_payload(payload)
  end
end
