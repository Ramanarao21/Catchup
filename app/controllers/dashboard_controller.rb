class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    @posts = Post.includes(:user).order(created_at: :desc)
  end

  def index
    @posts = Post.where(user: current_user.friends).or(Post.where(user: current_user)).order(created_at: :desc)
  end
end
