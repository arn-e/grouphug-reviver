require_relative '../config'

class CreateConfessions < ActiveRecord::Migration
  def change
    create_table :confessions do |t|
      t.integer   :number
      t.string    :text
    end
  end
end