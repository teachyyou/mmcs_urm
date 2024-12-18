class AddInstructionsArrayToMachines < ActiveRecord::Migration[8.0]
  def change
    add_column :machines, :instructions, :json
  end
end
