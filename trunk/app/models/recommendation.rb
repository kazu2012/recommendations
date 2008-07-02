class Recommendation < ActiveRecord::Base

  validates_presence_of :name, :user_id
  validates_uniqueness_of :name
  
  has_many :descriptions  
  has_many :justifications
  has_many :taggings
  
  belongs_to :user
    
  
  def delete
    self.is_deleted = true
    self.deleted_at = DateTime.now
    self.save!
    
  end

end