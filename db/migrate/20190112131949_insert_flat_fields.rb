require_relative '../../app/models/flat_field'
class InsertFlatFields < ActiveRecord::Migration[5.2]
  def change
    FlatField.where(name: 'Текст объявления', position: 1).first_or_create
    FlatField.where(name: 'Адрес', position: 2).first_or_create
    FlatField.where(name: 'Ссылка', position: 3).first_or_create
    FlatField.where(name: 'Телефон', position: 4).first_or_create
    FlatField.where(name: 'Цена', position: 5).first_or_create
    FlatField.where(name: 'Общая площадь', position: 6).first_or_create
    FlatField.where(name: 'Цена 1 кв.м.', position: 7).first_or_create
    FlatField.where(name: 'Жилая площадь', position: 8).first_or_create
    FlatField.where(name: 'Площадь кухни', position: 9).first_or_create
    FlatField.where(name: 'Этаж', position: 10).first_or_create
    FlatField.where(name: 'Этажей в доме', position: 11).first_or_create
    FlatField.where(name: 'Тип дома', position: 12).first_or_create
    FlatField.where(name: 'Количество комнат', position: 13).first_or_create
    FlatField.where(name: 'Фото', position: 14).first_or_create
  end
end
