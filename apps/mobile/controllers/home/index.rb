module Mobile
  module Controllers
    module Home
      class Index
        include Mobile::Action
        before :check_request!

        def call(params)
        end

        private

        def check_request!
          redirect_to "/mobile/#{params[:request]}", status: 301 if params[:request].present?
        end
      end
    end
  end
end
