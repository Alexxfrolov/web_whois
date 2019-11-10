module Web
  module Controllers
    module Application
      def redirect_requests!
        return unless params[:request]

        detect_user_agent
        check_request
      end

      private

      def check_request
        if request.path.match?(/^https?:\/\//) || params[:request].match?(/^www\./) || request.path == "/"
          cleaned_request = params[:request].gsub(/^www\./, "")
          redirect_to "/#{cleaned_request}", status: 301
        end
      end

      def detect_user_agent
        type = DeviceDetector.new(request.user_agent).device_type
        if ["console", nil ].include?(type)
          redirect_to "/#{params[:request]}/json", status: 301
        end
      end
    end
  end
end
