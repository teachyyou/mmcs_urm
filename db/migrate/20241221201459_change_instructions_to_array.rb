class ChangeInstructionsToArray < ActiveRecord::Migration[8.0]
  def change
    change_column :machines, :instructions, :text, array: true, default: [], using: "regexp_split_to_array(instructions::text, ',')"
  end
end
