class Posts::Update < AuthenticatedAction
  route do
    post = PostQuery.new.preload_user.find(id)

    if post.user == @current_user
      post = PostForm.update!(post, params)
      json Posts::ShowSerializer.new(post: post), Status::OK
    else
      head 401
    end
  end
end
