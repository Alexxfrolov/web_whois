# frozen_string_literal: true

module Mappers
  # used to parse response from whois service
  class WrapResponse
    def call(response)
      {
        meta: { created_at: Time.now },
        data: Array(response&.parser&.parsers).map { |parser| WhoisRecord.new(parser).call }
      }.to_json
    end
  end
end
