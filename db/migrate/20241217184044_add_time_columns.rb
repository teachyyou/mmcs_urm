class AddTimeColumns < ActiveRecord::Migration[8.0]
  def change
    add_timestamps :machines, null: true
  end
end
