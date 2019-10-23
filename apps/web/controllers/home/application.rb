module Web
  module Controllers
    module Home
      module Application
        TYPES = %i[mobile console web].freeze

        def detect_user_agent
          type = DeviceDetector.new(request.user_agent).device_type

          unless type
            redirect_to "/#{params[:request]}/json", status: 301
          end
        end
      end
    end
  end
end
