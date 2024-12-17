class AddColumnsToMachines < ActiveRecord::Migration[8.0]
  def change
    add_column :machines, :name, :string
    add_column :machines, :description, :string
    add_column :machines, :input_counts, :integer
    add_column :machines, :author, :string
    add_column :machines, :archived_at, :string
  end
end
