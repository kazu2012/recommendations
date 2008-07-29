class Recommendation < ActiveRecord::Base

  validates_presence_of :name, :user_id
  validates_uniqueness_of :name
  
  has_many :descriptions  
  has_many :justifications
  has_many :taggings
  has_many :tags, :through => :taggings
  
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
  
  def text_tags
    if self.taggings.size > 0
      tags = Array.new
      self.taggings.each do |tagging|
        tags << tagging.tag_text
      end
      tags.sort!
    end  
  end  
  

end
