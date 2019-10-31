module Mobile
  module Views
    module Home
      class Index
        include Mobile::View

        def search_form
          form_for :show, "/mobile/", method: :get, class: "search-form" do
            text_field :request, name: :request, class: "search-form__input", placeholder: "For example: google.com, 8.8.8.8"

            submit "Get WHOIS now", class: "search-form__button"
          end
        end

        def curl
          "curl https://getwhois.io/google.com/json"
        end
      end
    end
  end
end
