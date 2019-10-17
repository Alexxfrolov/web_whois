# frozen_string_literal: true

module Api
  module Controllers
    module V1
      # base controller get information by request
      class Whois
        include Api::Action
        include Import['services.query_reporter']

        accept :json

        params do
          optional(:query).filled(:str?)
        end

        def call(params)
          halt 400 unless params.valid?

          status(*query_reporter.call(params[:query]))
        end
      end
    end
  end
end
