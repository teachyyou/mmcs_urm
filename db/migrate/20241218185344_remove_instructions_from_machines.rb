class RemoveInstructionsFromMachines < ActiveRecord::Migration[8.0]
  def change
    remove_column :machines, :instructions, :string
  end
end
