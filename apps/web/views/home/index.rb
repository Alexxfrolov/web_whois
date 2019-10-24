module Web
  module Views
    module Home
      class Index
        include Web::View

        def search_form
          form_for :show, "/", method: :get, class: "search-form" do
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
