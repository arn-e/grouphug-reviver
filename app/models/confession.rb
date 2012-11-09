require_relative '../../db/config'

class Confession < ActiveRecord::Base

  validates :number, :uniqueness => true

end