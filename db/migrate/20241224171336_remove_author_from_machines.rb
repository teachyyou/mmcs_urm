class RemoveAuthorFromMachines < ActiveRecord::Migration[8.0]
  def change
    remove_column :machines, :author, :string
  end
end
