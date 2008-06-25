class Description < ActiveRecord::Base

  belongs_to :recommendation
  belongs_to :user
  validates_presence_of :description, :user_id

end
