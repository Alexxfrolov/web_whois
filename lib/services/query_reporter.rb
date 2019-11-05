# frozen_string_literal: true

module Services
  # used to get report from whois service
  class QueryReporter
    RETRIES = 3

    include Import["whois"]
    include Import["redis"]
    include Import["mappers.wrap_response"]

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
      data = redis.get(query)
      return unless data

      [200, data]
    rescue
      puts "ERROR WHILE GETTING CACHE DATA!!!"
      nil
    end

    def cache_response!(query, data)
      redis.set(query, data)
      redis.expire(query, expire_time)
    rescue
      puts "ERROR WHILE CACHING DATA!!!"
    end

    def do_response(query)
      data = whois.lookup(query)
      wraped_data = wrap_response.call(data)

      cache_response!(query, wraped_data)

      [200, wraped_data]
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
