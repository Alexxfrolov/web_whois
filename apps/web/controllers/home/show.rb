module Web
  module Controllers
    module Home
      class Show
        include Web::Action
        include Import["services.query_reporter"]
        expose :result

        def call(params)
          status, @result = query_reporter.call(params[:request])

          if status == 200
            @result = JSON.parse(@result)["whois_record"]&.deep_symbolize_keys!
          else
            {}
          end
        end
      end
    end
  end
end
