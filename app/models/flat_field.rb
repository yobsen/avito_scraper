require_relative 'application_record'

class FlatField < ApplicationRecord
  validates :name, presence: true

  def self.insert_defaults
    create(name: 'Текст объявления', position: 1)
    create(name: 'Адрес', position: 2)
    create(name: 'Ссылка', position: 3)
    create(name: 'Телефон', position: 4)
    create(name: 'Цена', position: 5)
    create(name: 'Общая площадь', position: 6)
    create(name: 'Цена 1 кв.м.', position: 7)
    create(name: 'Жилая площадь', position: 8)
    create(name: 'Площадь кухни', position: 9)
    create(name: 'Этаж', position: 10)
    create(name: 'Этажей в доме', position: 11)
    create(name: 'Тип дома', position: 12)
    create(name: 'Количество комнат', position: 13)
    create(name: 'Фото', position: 14)
  end
end
