# frozen_string_literal: true

require 'active_record'
require_relative './models/movie'

def db_configuration
  db_configuration_file = File.join(File.expand_path(__dir__), '..', 'db', 'config.yml')
  YAML.safe_load(File.read(db_configuration_file))
end

ActiveRecord::Base.establish_connection(db_configuration['development'])
