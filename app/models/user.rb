class User < ApplicationRecord
  has_many :user_stocks
  has_many :stocks, through: :user_stocks
  has_many :friendships
  has_many :friends, through: :friendships

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def under_stock_limit?
    stocks.count < 10
  end

  def already_tracked?(ticker)
    stock = Stock.check_db(ticker)
    return false unless stock
    stocks.where(id: stock.id).exists?
  end

  def can_track_stock?(ticker)
    under_stock_limit? && !already_tracked?(ticker)
  end

  def full_name
    return "#{first_name} #{last_name}" if first_name || last_name
    "Anonymous"
  end

  def self.search(param)
    param.strip!
    response = (first_name_search(param) + last_name_search(param) + email_search(param)).uniq
    return nil unless response
    response
  end

  def self.first_name_search(param)
    matches('first_name', param)
  end

  def self.last_name_search(param)
    matches('last_name', param)
  end

  def self.email_search(param)
    matches('email', param)
  end

  def self.matches(field_name, param)
    where("#{field_name} like ?", "%#{param}%")
  end

  def except_current_user(users)
    users.reject { |user| user.id == self.id }
  end

  def not_friends_with?(user_id)
    !self.friends.where(id: user_id).exists?
  end

  def friend_since(friend_id)
    user = self.friendships.where(friend_id: friend_id).first
    user.created_at 
  end

end
