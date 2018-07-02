class Posts::Create < AuthenticatedAction
  route do
    post = PostForm.create!(params, author: @current_user.not_nil!)
    json Posts::ShowSerializer.new(post), Status::Created
  end
end
