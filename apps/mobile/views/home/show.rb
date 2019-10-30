module Mobile
  module Views
    module Home
      class Show
        include Mobile::View

        def search_form
          form_for :show, "/", method: :get, class: "search-form" do
            text_field :request, name: :request, class: "search-form__input", placeholder: "For example: google.com, 8.8.8.8"

            submit "Get WHOIS now", class: "search-form__button"
          end
        end

        def title
          params[:request].to_s
        end

        def created_on
          result[0]&.fetch(:created_on)&.split(" ")&.first
        end

        def expires_on
          result[0]&.fetch(:expires_on)&.split(" ")&.first
        end

        def updated_on
          result[0]&.fetch(:updated_on)&.split(" ")&.first
        end

        def registrant
          result.find { |i| i[:registrant_contacts].present? }&.fetch(:registrant_contacts)&.first&.
            transform_values(&:to_s) || {}
        end

        def registrant_address
          registrant.values_at(*%i[country_code country state city address]).
            select(&:present?).join(", ")
        end

        def tech_contacts
          result.find { |i| i[:technical_contacts].present? }&.fetch(:technical_contacts)&.first&.
            transform_values(&:to_s) || {}
        end

        def tech_address
          tech_contacts.values_at(*%i[country_code country state city address]).
            select(&:present?).join(", ")
        end

        def nameservers
          Array(result.find { |i| i[:nameservers].present? }&.fetch(:nameservers)).
            map { |i| i.transform_values(&:to_s) } || []
        end

        def raw_text
          result[0]&.fetch(:raw_text)&.strip
        end
      end
    end
  end
end
