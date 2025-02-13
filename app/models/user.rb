class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :friendships
  has_many :friends, -> { where(friendships: { accepted: true }) }, through: :friendships, source: :friend

  # Friend requests that the user has sent
  has_many :sent_friend_requests, -> { where(accepted: false) }, class_name: "Friendship", foreign_key: "user_id"

  # Friend requests that the user has received
  has_many :received_friend_requests, -> { where(accepted: false) }, class_name: "Friendship", foreign_key: "friend_id"

  # **Confirmed friendships (both users have accepted)**
  has_many :confirmed_friendships, -> { where(accepted: true) }, class_name: "Friendship"
  has_many :confirmed_friends, through: :confirmed_friendships, source: :friend

  has_many :posts
  has_many :thoughts
end
