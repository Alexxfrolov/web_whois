# frozen_string_literal: true

module Mappers
  # used to parse response from whois service
  class WrapResponse
    def call(response)
      {
        meta: { created_at: Time.now },
        whois_record:
          merge(Array(response&.parser&.parsers).map { |parser| WhoisRecord.new(parser).call })
      }
    end

    private

    def merge(data)
      data.inject({}) do |new, old|
        old.keys.each { |key| new[key] ||= old[key] }
        new
      end
    end
  end
end
