module Web
  module Views
    module Home
      class Show
        include Web::View

        def search_form
          form_for :show, "/", method: :get, class: "search-form" do
            text_field :request, name: :request, class: "search-form__input", placeholder: "For example: google.com, 8.8.8.8"

            submit "Get WHOIS now", class: "search-form__button"
          end
        end

        def title
          params[:request]
        end

        def created_on
          result[:created_on]&.split(" ")&.first
        end

        def expires_on
          result[:expires_on]&.split(" ")&.first
        end

        def updated_on
          result[:updated_on]&.split(" ")&.first
        end

        def registrant
          result[:registrant_contacts]&.first&.transform_values(&:to_s) || {}
        end

        def registrant_address
          registrant.values_at(*%i[country_code country state city address]).
            select(&:present?).join(", ")
        end

        def tech_contacts
          result[:technical_contacts]&.first&.transform_values(&:to_s) || {}
        end

        def tech_address
          tech_contacts.values_at(*%i[country_code country state city address]).
            select(&:present?).join(", ")
        end

        def nameservers
          Array(result[:nameservers]).map { |i| i.transform_values(&:to_s) }
        end

        def raw_text
          result[:raw_text].to_s.gsub(/^[ ]{2,}/, "")
        end
      end
    end
  end
end
