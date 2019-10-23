module Web
  module Controllers
    module Home
      class Show
        include Web::Action
        include Application

        before :detect_user_agent

        def call(params)
        end
      end
    end
  end
end
