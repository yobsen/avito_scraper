require_relative '../../app/models/flat_field'

class SplitAddressForFlatFields < ActiveRecord::Migration[5.2]
  def change
    FlatField.find_by(name: 'Адрес').destroy
    FlatField.where(name: 'Район', position: 2).first_or_create
    FlatField.where(name: 'Улица', position: 2).first_or_create
  end
end
