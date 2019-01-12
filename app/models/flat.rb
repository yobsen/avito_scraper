# frozen_string_literal: true

require_relative 'application_record'

class Flat < ApplicationRecord
  validates :avito_id, presence: true

  def self.upsert(avito_id, properties)
    db_flat = Flat.where(avito_id: avito_id).first_or_initialize
    db_flat.properties = properties
    db_flat.save!
  end

  def self.to_csv
    CSV.open("reports/#{Time.now.strftime('%-d-%B-%Y_%H:%M')}_avito_scraper.csv", 'w') do |csv|
      csv << fields

      Flat.all.each do |flat|
        csv << fields.map { |field| flat[:properties][field] }
      end
    end
  end

  def self.fields
    fields = Flat.pluck(:properties).map(&:keys).flatten.uniq.sort

    ordered_fields = FlatField.order(position: :asc).pluck(:name)

    ordered_fields + (fields - ordered_fields)
  end
end
