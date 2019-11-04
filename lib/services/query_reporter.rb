# frozen_string_literal: true

module Services
  # used to get report from whois service
  class QueryReporter
    RETRIES = 3

    include Import["whois"]
    include Import["mappers.wrap_response"]

    def call(query)
      retries ||= 0

      query = query.to_s.squish.gsub(/\/|www.|https?:\/\//, "")
      status, data = do_response(query)
      while [408, 503].include?(status) && retries < RETRIES
        status, data = do_response(query)
        retries += 1
      end

      [status, data]
    end

    private

    def do_response(query)
      data = whois.lookup(query)

      [200, wrap_response.call(data)]
    rescue Whois::AllocationUnknown
      [400, wrap_response.call(nil)]
    rescue Whois::ServerNotFound
      [400, wrap_response.call(nil)]
    rescue Timeout::Error
      [408, wrap_response.call(nil)]
    rescue Whois::ConnectionError
      [503, wrap_response.call(nil)]
    rescue StandardError
      [500, wrap_response.call(nil)]
    end
  end
end
