# frozen_string_literal: true

module Mappers
  # base class with data structure
  class ParseRecord
    attr_reader :record, :raw_text

    def initialize(raw)
      @raw_text = raw.dup.to_s.force_encoding("utf-8")
      set_record!
    end

    def disclaimer
      val_by_regexp(/disclaimer/)
    end

    def domain
      val_by_regexp(/domain/)
    end

    def domain_id
      val_by_regexp(/domain id/)
    end

    def status
      available? ? "available" : "registered"
    end

    def available?
      @record["available"] || false
    end

    def registered?
      !available?
    end

    def created_on
      convert_date_to_utc val_by_regexp(/creation date|created/)
    end

    def updated_on
      convert_date_to_utc val_by_regexp(/updated|modified/) || @raw_text[/updated on(.*?)(.*)/m, 2]&.strip
    end

    def expires_on
      convert_date_to_utc val_by_regexp(/expiry|expiration|paid-till/)
    end

    def registrar
      {
        id: val_by_regexp(/regist(.*?) iana id/),
        name: val_by_regexp(/registrar:/),
        organization: val_by_regexp(/registrar:/),
        url: val_by_regexp(/registrar url/)
      }
    end

    def registrant_contacts
      [
        {
          id: val_by_regexp(/registrant id/),
          type: val_by_regexp(/registrant type/),
          name: val_by_regexp(/registrant name/),
          organization: val_by_regexp(/registrant org/),
          address: val_by_regexp(/registrant address/),
          city: val_by_regexp(/registrant city/),
          zip: val_by_regexp(/registrant post(.*)(code|zip)/),
          state: val_by_regexp(/registrant state/),
          country: val_by_regexp(/registrant country/),
          country_code: val_by_regexp(/registrant country_code/),
          phone: val_by_regexp(/registrant phone/),
          fax: val_by_regexp(/registrant fax/),
          email: val_by_regexp(/registrant email/),
          url: val_by_regexp(/registrant url/),
          created_on: val_by_regexp(/registrant create/),
          updated_on: val_by_regexp(/registrant update/)
        }
      ]
    end

    def admin_contacts
      [
        {
          id: val_by_regexp(/admin id/),
          type: val_by_regexp(/admin type/),
          name: val_by_regexp(/admin name/),
          organization: val_by_regexp(/admin org/),
          address: val_by_regexp(/admin address/),
          city: val_by_regexp(/admin city/),
          zip: val_by_regexp(/admin post(.*)(code|zip)/),
          state: val_by_regexp(/admin state/),
          country: val_by_regexp(/admin country/),
          country_code: val_by_regexp(/admin country_code/),
          phone: val_by_regexp(/admin phone/),
          fax: val_by_regexp(/admin fax/),
          email: val_by_regexp(/admin email/),
          url: val_by_regexp(/admin url|admin-contact/),
          created_on: val_by_regexp(/admin create/),
          updated_on: val_by_regexp(/admin update/)
        }
      ]
    end

    def technical_contacts
      [
        {
          id: val_by_regexp(/tech id/),
          type: val_by_regexp(/tech type/),
          name: val_by_regexp(/tech name/),
          organization: val_by_regexp(/tech org/),
          address: val_by_regexp(/tech address/),
          city: val_by_regexp(/tech city/),
          zip: val_by_regexp(/tech post(.*)(code|zip)/),
          state: val_by_regexp(/tech state/),
          country: val_by_regexp(/tech country/),
          country_code: val_by_regexp(/tech country_code/),
          phone: val_by_regexp(/tech phone/),
          fax: val_by_regexp(/tech fax/),
          email: val_by_regexp(/tech email/),
          url: val_by_regexp(/tech url/),
          created_on: val_by_regexp(/tech create/),
          updated_on: val_by_regexp(/tech update/)
        }
      ]
    end

    def nameservers
      []
    end

    private

    def set_record!
      @record ||= {}

      @raw_text.scan(/^[a-zA-Z -]+:/).each_cons(2) do |elements|
        key = elements[0]&.squish&.downcase
        value =
          if elements[1] then @raw_text[/#{elements[0]}(.*?)#{elements[1]}/m, 1]
          else @raw_text[/#{elements[1]}(.*?)(.*)/m, 2]
          end
        @record[key] = value&.squish
      end

      @record["available"] = true if @raw_text.match?(/domain not found|no entries found/i)
    end

    def val_by_regexp(regexp)
      searched_key = @record.keys.find { |key| key.to_s.match(regexp) }
      @record[searched_key]
    end

    def convert_date_to_utc(date)
      Time.iso8601(date).to_s
    rescue ArgumentError
      nil
    end
  end
end
