require_relative 'application_record'

class FlatField < ApplicationRecord
  validates :name, presence: true, uniqueness: { case_sensitive: false }
end
