class AddAuthorToMachines < ActiveRecord::Migration[8.0]
  def change
    add_column :machines, :author, :bigint
  end
end
