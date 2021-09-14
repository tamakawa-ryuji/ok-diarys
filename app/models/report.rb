class Report < ApplicationRecord
  belongs_to :user
  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy 
   

   validates :achivement, presence: true, length: { maximum: 250 } 
   validates :improvement, presence: true, length: { maximum: 250 } 
   validates :progress1, presence: true
   validates :progress2, presence: true
   validates :progress3, presence: true
   

   
   
  validate :user_can__create_only_one_report_per_day, if: :new_record?

  def user_can__create_only_one_report_per_day
    if user.reports.find_by(day1: Time.zone.now).present?
      errors.add(:day1, '既に登録されています')
    end
  end
end