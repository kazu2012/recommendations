class Recommendation < ActiveRecord::Base

  validates_presence_of :name, :user_id
  validates_uniqueness_of :name
  
  has_many :descriptions  
  has_many :justifications
  has_many :taggings
  
  belongs_to :user
  
  def description
    Description.find(:first, :conditions => ["recommendation_id = ?", self.id], :order => ["created_at DESC"])
  end  

  def justification
    Justification.find(:first, :conditions => ["recommendation_id = ?", self.id], :order => ["created_at DESC"])
  end
  
  def delete
    self.is_deleted = true
    self.deleted_at = DateTime.now
    self.save!
    
  end
  
  def tags
    if self.taggings.size > 0
      tags = Array.new
      self.taggings.each do |tagging|
        tags << tagging.tag.name
      end
      tags.sort!
    end  
  end  
  

end
