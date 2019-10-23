# frozen_string_literal: true

require "dry-container"
require "dry-auto_inject"
require "whois"
require "device_detector"

# require_relative 'services/query_reporter'
# require_relative 'mappers/response'

# used to store project dependencies
# For more look https://dry-rb.org/gems/dry-container
class Container
  extend Dry::Container::Mixin

  register("whois") { Whois::Client.new }

  namespace("services") do
    register("query_reporter") { Services::QueryReporter.new }
  end

  namespace("mappers") do
    register("wrap_response") { Mappers::WrapResponse.new }
  end
end

Import = Dry::AutoInject(Container)
