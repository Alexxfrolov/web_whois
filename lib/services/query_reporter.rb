# frozen_string_literal: true

module Services
  # used to get report from whois service
  class QueryReporter
    RETRIES = 3

    include Import["whois"]
    include Import["redis"]
    include Import["mappers.wrap_response"]
    include Import["services.fill_ip"]

    def call(query)
      retries ||= 0

      query = query.to_s.squish.downcase.gsub(/\/|www.|https?:\/\//, "")
      status, data = cached_response(query) || do_response(query)

      while [408, 503].include?(status) && retries < RETRIES
        status, data = do_response(query)
        retries += 1
      end

      [status, data]
    end

    private

    def expire_time
      ENV["REDIS_EXPIRE"] || 10800
    end

    def cached_response(query)
      data = redis.get(query) if ENV["USE_CACHE"] == "true"
      return unless data

      [200, data]
    rescue
      puts "ERROR WHILE GETTING CACHE DATA!!!"
      nil
    end

    def cache_response!(query, data)
      redis.set(query, data) if ENV["USE_CACHE"] == "true"
      redis.expire(query, expire_time) if ENV["USE_CACHE"] == "true"
    rescue
      puts "ERROR WHILE CACHING DATA!!!"
    end

    def do_response(query)
      data = whois.lookup(query)
      wraped_data = wrap_response.call(data)
      full_data = fill_ip.call(wraped_data).to_json

      cache_response!(query, full_data)

      [200, full_data]
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
