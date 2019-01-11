# frozen_string_literal: true

require 'watir'
require 'pry'
require 'csv'
# require 'mini_magick'
require 'rtesseract'
require 'headless'

require_relative 'app/models/flat_field'
require_relative 'app/models/flat'
require_relative 'lib/translit'

def db_configuration
  db_configuration_file = File.join(File.expand_path(__dir__), 'db', 'config.yml')
  YAML.safe_load(File.read(db_configuration_file))
end

ActiveRecord::Base.establish_connection(db_configuration['development'])

Watir.default_timeout = 600

class AvitoScraper
  def initialize(root)
    @root = root
    @flats = []
    @tries = 50
    @all_ids = []
  end

  def browser
    return @browser if @browser

    @browser = Watir::Browser.new :firefox, headless: true
  end

  def fetch_flats_from_page(url)
    open_with_retries(url)

    sleep 3
    flats_nodes = browser.divs(class: 'item_table')
    print ", flats: #{flats_nodes.count} \n\n"

    @flats = flats_nodes.map do |flat|
      avito_id = flat.attribute('data-item-id')
      @all_ids.push(avito_id)
      avito_name = flat.span(itemprop: 'name').text

      db_flat = Flat.find_by(avito_id: avito_id)
      puts " page: #{@page}, skip: #{avito_id}, name: #{avito_name}, db_name: #{db_flat.properties['Название']}" if db_flat
      next if db_flat

      { avito_id: avito_id,
        properties: {
          'Фото' => flat.a(class: 'item-missing-photo').exists? ? 'нет' : 'есть',
          'Цена' => flat.span(class: 'price').attribute('content'),
          'Название' => avito_name,
          'Ссылка' => flat.link(class: 'item-description-title-link').attribute('href'),
          'Адрес' => flat.p(class: 'address').text
        } }
    end.compact
  end

  def fetch_additional_info
    @flats.each_with_index do |flat, index|
      benchmark_start = Time.now

      print " page: #{@page}, flat: #{index + 1}/#{@flats.count}, avito_id: #{flat[:avito_id]}"

      open_with_retries(flat[:properties]['Ссылка'])
      browser.lis(class: 'item-params-list-item').each do |param|
        key, value = param.text.split(': ')
        flat[:properties][key] = value.gsub(' м²', '').gsub(/(\d)\.(\d)/, '\1,\2')
      end

      flat[:properties]['Контактное лицо'] = browser.div(class: 'seller-info-value').text

      description_div = browser.div(class: 'item-description-text')
      flat[:properties]['Текст объявления'] = description_div.text if description_div.exists?

      flat[:properties]['Цена 1 кв.м.'] =
        (flat[:properties]['Цена'].to_f / flat[:properties]['Общая площадь'].to_f).round(1).to_s.tr('.', ',')

      browser.link(class: 'item-phone-button_card').click
      phone_base64 = browser.div(class: 'item-phone-big-number').img.attribute('src')
      phone_png = Base64.decode64(phone_base64['data:image/png;base64,'.length..-1])
      File.open('tmp/phone.png', 'wb') { |f| f.write(phone_png) }
      flat[:properties]['Телефон'] = RTesseract.new('tmp/phone.png').to_s.strip

      Flat.upsert(flat[:avito_id], flat[:properties])
      print ", saved: #{(Time.now - benchmark_start).to_i}s.\n"
    end
  end

  def pull_pages
    (1..100).each do |page|
      @page = page

      url = "#{@root}?p=#{page}"
      print " page: #{page}"

      fetch_flats_from_page(url)
      fetch_additional_info
      Flat.where.not(avito_id: @all_ids).delete_all
    end
  end

  private

  def open_with_retries(url)
    browser.goto(url)
  rescue StandardError => ex
    raise if @tries.zero?

    sleep 1
    @browser&.close
    @browser = nil
    @tries -= 1
    puts "\n  url: #{url}"
    puts "error: #{ex.class} detected, retries left: #{@tries}\n\n"

    open_with_retries(url)
  end
end

scraper = AvitoScraper.new('http://www.avito.ru/stavropol/kvartiry/prodam')
binding.pry
