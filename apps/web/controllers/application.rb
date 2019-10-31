module Web
  module Controllers
    module Application
      def detect_user_agent!
        type = DeviceDetector.new(request.user_agent).device_type

        case type
        when "smartphone", "feature phone", "tablet"
          redirect_to "/mobile/", status: 301
        when "console", nil then redirect_to "/#{params[:request]}/json", status: 301
        end
      end
    end
  end
end
