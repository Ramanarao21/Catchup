class UsersController < ApplicationController
    def show
      @user = User.find(params[:id])  # Fetch the selected user
      @posts = @user.posts            # Fetch their posts
    end
  end
  