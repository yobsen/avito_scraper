# frozen_string_literal: true

require 'active_record'

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
end

class Flat < ApplicationRecord
  validates :avito_id, presence: true

  def self.upsert(avito_id, properties)
    db_flat = Flat.where(avito_id: avito_id).first_or_initialize
    db_flat.properties = properties
    db_flat.save
  end

  def self.to_csv
    CSV.open("reports/#{Time.now.strftime('%-d-%B-%Y_%H:%M')}_avito_scraper.csv", 'w') do |csv|
      csv << fields

      Flat.all.each do |flat|
        csv << fields.map { |field| flat[:properties][field] }
      end
    end
 end

  private

  def self.fields
    Flat.pluck(:properties).map(&:keys).flatten.uniq.sort
  end
end
