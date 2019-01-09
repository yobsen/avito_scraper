class CreateFlatFields < ActiveRecord::Migration[5.2]
  def change
    create_table :flat_fields do |t|
      t.string :name
      t.integer :position
    end
  end
end
