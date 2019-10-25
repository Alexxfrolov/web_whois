# frozen_string_literal: true

module Services
  # used to get report from whois service
  class QueryReporter
    include Import["whois"]
    include Import["mappers.wrap_response"]

    def call(query)
      do_response(query)
    end

    private

    def do_response(query)
      data = whois.lookup(query)

      [200, wrap_response.call(data)]
    rescue Whois::AllocationUnknown
      [400, wrap_response.call(nil)]
    rescue Whois::ServerNotFound
      [400, wrap_response.call(nil)]
    rescue Whois::ConnectionError
      [503, wrap_response.call(nil)]
    # rescue StandardError
    #   [500, wrap_response.call(nil)]
    end
  end
end
