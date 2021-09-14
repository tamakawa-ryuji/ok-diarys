class Post < ApplicationRecord
  belongs_to :user
  
   validates :goal1, presence: true, length: { maximum: 100 } 
   validates :goal2, presence: true, length: { maximum: 100 }
   validates :goal3, presence: true, length: { maximum: 100 } 
   validates :content, presence: true, length: { maximum: 250 } 
   validates :feeling1 , presence: true
   validates :feeling2, presence: true




  validate :user_can__create_only_one_post_per_day, if: :new_record?
  def user_can__create_only_one_post_per_day
    if user.posts.find_by(day: Time.zone.now).present?
      errors.add(:day, '既に登録されています')
    end
  end
end

   
   

