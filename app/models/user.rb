class User < ApplicationRecord
    before_save { self.email.downcase! }
    validates :name, presence: true, length: { maximum: 50 }
    validates :email, presence: true, length: { maximum: 255 },
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
                    uniqueness: { case_sensitive: false }
    validates :goal, length: { maximum: 100 }                    
    validates :introduction, length: { maximum: 250 }    
                    
                    
  validate :day_after_today
  def day_after_today
    unless goal_day == nil
      errors.add(:goal_day, 'は過去の日付は入力できません') if goal_day < Date.today
    end
  end
    
    
  has_secure_password
  has_many :comments, dependent: :destroy  
  has_many :posts, dependent: :destroy
  has_many :reports, dependent: :destroy
  has_many :relationships,dependent: :destroy
  has_many :followings, through: :relationships, source: :follow 
  has_many :reverses_of_relationship, class_name: 'Relationship', foreign_key: 'follow_id' ,dependent: :destroy
  has_many :followers, through: :reverses_of_relationship, source: :user
  
  has_many :likes, dependent: :destroy
  has_many :favorites, through: :likes, source: :report
  
  
  def follow(other_user)
    unless self == other_user
      self.relationships.find_or_create_by(follow_id: other_user.id)
    end
  end

  def unfollow(other_user)
    relationship = self.relationships.find_by(follow_id: other_user.id)
    relationship.destroy if relationship
  end

  def following?(other_user)
    self.followings.include?(other_user)
  end 
  
  def feed_reports
    Report.where(user_id: self.following_ids + [self.id])
  end

  
  def like(report)
      likes.find_or_create_by(report_id: report.id)
  end
  
  def unlike(report)
   like = likes.find_by(report_id: report.id)
    like.destroy if like
  end
  
  def like?(report)
    self.favorites.include?(report)
  end

  
  # 今日の日付のpostを抽出する
  def todays_post
    self.posts.where(day: Time.zone.today).first
  end

  
end
