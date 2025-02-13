class PostsController < ApplicationController
    def new
      @post = Post.new
    end
  
    def create
      @post = current_user.posts.build(post_params)
      if @post.save
        redirect_to root_path, notice: "Your thought has been shared!"
      else
        render :new, status: :unprocessable_entity
      end
    end
  
    private
  
    def post_params
      params.require(:post).permit(:content)
    end
  end
  