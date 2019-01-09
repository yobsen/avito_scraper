# frozen_string_literal: true

class CreateFlats < ActiveRecord::Migration[5.2]
  def change
    create_table :flats do |t|
      t.integer :avito_id
      t.json :properties

      t.timestamps
    end
  end
end
