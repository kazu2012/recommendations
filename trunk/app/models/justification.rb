class Justification < ActiveRecord::Base

  belongs_to :recommendation
  belongs_to :user
  
  validates_presence_of :user_id

end
