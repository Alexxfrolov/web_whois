module Mobile
  module Controllers
    module Home
      class Show
        include Mobile::Action
        include Import["services.query_reporter"]
        expose :result

        def call(params)
          _, @result = query_reporter.call(params[:request])

          if @result
            @result = JSON.parse(@result)["whois_record"]&.deep_symbolize_keys!
          else
            []
          end
        end
      end
    end
  end
end
