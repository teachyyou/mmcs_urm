class AddInstructionsToMachines < ActiveRecord::Migration[8.0]
  def change
    add_column :machines, :instructions, :string, array:true, default: []
  end
end
