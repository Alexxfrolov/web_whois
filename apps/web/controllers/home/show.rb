module Web
  module Controllers
    module Home
      class Show
        include Web::Action
        include Import["services.query_reporter"]
        expose :result

        def call(params)
          _, @result = query_reporter.call(params[:request])

          if @result
            @result = JSON.parse(@result)["data"].map(&:deep_symbolize_keys!)
          else
            []
          end
        end
      end
    end
  end
end
