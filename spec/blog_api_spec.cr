require "./spec_helper"

describe App do
  visitor = AppVisitor.new

  describe "/" do
    it "says hello" do
      visitor.visit("/")

      visitor.response_body.should eq ({ "hello" => "Hello World from Home::Index" })
    end
  end

  describe "/posts" do
    it "returns latest posts" do
      user = UserBox.create
      post1 = PostBox.new.user_id(user.id).title("Post 1").create
      post2 = PostBox.new.user_id(user.id).title("Post 2").create

      visitor.visit("/posts")

      visitor.response_body["total"].should eq 2
      visitor.response_body["posts"].size.should eq 2
      visitor.response_body["posts"][0]["title"].should eq "Post 1"
    end

    it "shows post" do
      user = UserBox.create
      post1 = PostBox.new.user_id(user.id).title("Dope post").create

      visitor.visit("/posts/#{post1.id}")
      visitor.response_body["title"].should eq "Dope post"
    end

    it "creates post" do
      user = UserBox.create
      token = user.generate_token

      visitor.post("/posts", new_post_data, { "Authorization" => token })

      visitor.response_body["title"].should eq new_post_data["post:title"]
    end

    it "rejects unauthenticated requests to protected actions" do
      visitor.post("/posts", new_post_data)
      visitor.response.status_code.should eq 401
    end
  end

  describe "auth" do
    it "signs in valid user" do
      user = UserBox.new.create

      visitor.post("/auth/sign_in", ({
        "sign_in:email" => user.email,
        "sign_in:password" => "password"
      }))

      visitor.response.status_code.should eq 200
      visitor.response.headers["Authorization"].should_not be_nil
    end

    it "rejects invalid user" do
      user = UserBox.new.create

      visitor.post("/auth/sign_in", ({
        "sign_in:email" => "wrong email",
        "sign_in:password" => "password"
      }))

      visitor.response.status_code.should eq 401
    end

    it "returns 401 on sign up" do
      visitor.post("/auth/sign_up", ({
        "sign_up:name" => "New User",
        "sign_up:email" => "test@email.com",
        "sign_up:password" => "password",
        "sign_up:password_confirmation" => "password"
      }))

      visitor.response.status_code.should eq 401
      # visitor.response.status_code.should eq 200
      # visitor.response.headers["Authorization"].should_not be_nil

      # UserQuery.new.email("test@email.com").first.should_not be_nil
    end
  end
end

def new_post_data
  ({
    "post:title" => "New Post",
    "post:content" => "Probably the best post you've ever read",
    "post:published_at" => Time.now.to_s,
    "post:tags" => "dope, informative",
    "post:comment_id" => "1"
  })
end