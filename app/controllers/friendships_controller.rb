class FriendshipsController < ApplicationController
  before_action :authenticate_user!

  def index
    @users = User.where.not(id: current_user.id)
                 .where.not(id: current_user.friends.pluck(:id)) # Exclude existing friends
  
    @pending_requests = Friendship.where(friend: current_user, accepted: false) # Requests received
    @friends = current_user.friendships.where(accepted: true).includes(:friend => :thoughts).map(&:friend)

  end
  
  
  

  def create
    friend = User.find_by(id: params[:friendship][:friend_id])
  
    if friend
      @friendship = current_user.friendships.build(friend: friend, status: "pending")
  
      if @friendship.save
        flash[:notice] = "Friend request sent!"
      else
        flash[:alert] = "Could not send request."
      end
    else
      flash[:alert] = "User not found."
    end
  
    redirect_to friendships_path
  end
  

  def accept
    friendship = Friendship.find(params[:id])
  
    if friendship.friend == current_user && !friendship.accepted
      friendship.update(accepted: true)

      Friendship.create(user: friendship.friend, friend: friendship.user, accepted: true)
      
      flash[:notice] = "Friend request accepted!"
    else
      flash[:alert] = "Something went wrong."
    end
  
    redirect_to friendships_path
  end
  

  def reject
    friendship = Friendship.find(params[:id])

    if friendship.friend == current_user && !friendship.accepted
      friendship.destroy
      flash[:notice] = "Friend request rejected!"
    else
      flash[:alert] = "Invalid request!"
    end
    redirect_to friendships_path
  end

  def destroy
    friendship = Friendship.find(params[:id])

    if friendship.user == current_user || friendship.friend == current_user
      friendship.destroy
      flash[:notice] = "Friend removed!"
    else
      flash[:alert] = "Unauthorized action!"
    end
    redirect_to friendships_path
  end
end
