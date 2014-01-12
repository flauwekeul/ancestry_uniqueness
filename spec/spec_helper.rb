require 'active_record'
require 'ancestry'
require 'ancestry_uniqueness'

ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: ':memory:')

RSpec.configure do |config|
  config.order = 'random'

  config.around do |example|
    ActiveRecord::Base.transaction do
      example.run
      raise ActiveRecord::Rollback
    end
  end
end
