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
      convert_date_to_utc val_by_regexp(/creation date|created|regdate/)
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
          id: val_by_regexp(/registrant id|orgid/),
          type: 1,
          name: val_by_regexp(/registrant name/),
          organization: val_by_regexp(/registrant org/) || val_by_regexp(/org|registrant/),
          address: val_by_regexp(/registrant address/) || val_by_regexp(/address/),
          city: val_by_regexp(/registrant city/) || val_by_regexp(/city/),
          zip: val_by_regexp(/registrant post(.*)(code|zip)|postalcode/),
          state: val_by_regexp(/registrant state|stateprov/),
          country: val_by_regexp(/registrant country/) || val_by_regexp(/country/),
          country_code: val_by_regexp(/registrant country_code/) || val_by_regexp(/country_code|countrycode/),
          phone: val_by_regexp(/registrant phone/) || val_by_regexp(/phone/),
          fax: val_by_regexp(/registrant fax/) || val_by_regexp(/fax/),
          email: val_by_regexp(/registrant email/) || val_by_regexp(/email/),
          url: val_by_regexp(/registrant url/) || val_by_regexp(/ref/),
          created_on: val_by_regexp(/registrant create/),
          updated_on: val_by_regexp(/registrant update/)
        }
      ]
    end

    def admin_contacts
      [
        {
          id: val_by_regexp(/admin id/),
          type: 2,
          name: val_by_regexp(/admin name/),
          organization: val_by_regexp(/admin org/),
          address: val_by_regexp(/admin address/),
          city: val_by_regexp(/admin city/),
          zip: val_by_regexp(/admin post(.*)(code|zip)/),
          state: val_by_regexp(/admin state/),
          country: val_by_regexp(/admin country/),
          country_code: val_by_regexp(/admin country_code/),
          phone: val_by_regexp(/admin phone/) || val_by_regexp(/phone/),
          fax: val_by_regexp(/admin fax/) || val_by_regexp(/fax/),
          email: val_by_regexp(/admin email/) || val_by_regexp(/email/),
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
          type: 3,
          name: val_by_regexp(/tech name/),
          organization: val_by_regexp(/tech org/) || val_by_regexp(/org|registrant/),
          address: val_by_regexp(/tech address/) || val_by_regexp(/address/),
          city: val_by_regexp(/tech city/) || val_by_regexp(/city/),
          zip: val_by_regexp(/tech post(.*)(code|zip)|postalcode/),
          state: val_by_regexp(/tech state|stateprov/),
          country: val_by_regexp(/tech country/) || val_by_regexp(/country/),
          country_code: val_by_regexp(/tech country_code/) || val_by_regexp(/country_code|countrycode/),
          phone: val_by_regexp(/tech phone/) || val_by_regexp(/phone/),
          fax: val_by_regexp(/tech fax/) || val_by_regexp(/fax/),
          email: val_by_regexp(/tech email/) || val_by_regexp(/email/),
          url: val_by_regexp(/tech url/),
          created_on: val_by_regexp(/tech create/),
          updated_on: val_by_regexp(/tech update/)
        }
      ]
    end

    def nameservers
      Array(val_by_regexp(/server/)&.split(/server|\n/)).select { |i| i.match?(/ns\./) }.map do |item|
        item.gsub!(/: /, "")
        name, ip4, ip6 = item.squish.split(" ")
        {
          name: name.chomp(".").chomp(","),
          ipv4: ip4.to_s.chomp(".").chomp(","),
          ipv6: ip6.to_s.chomp(".").chomp(",")
        }
      end
    end

    private

    def set_record!
      @record ||= {}
      keys = @raw_text.scan(/^[a-zA-Z -\/\\]+:/).reject { |i| i.match?(/http/) }
      keys.each_cons(2) do |first, second|
        key = first&.squish&.downcase
        value = @raw_text[/#{first}(.*?)#{second}/m, 1]
        @record[key] = value&.squish unless @record.has_key?(key)
      end

      last_key = keys.last&.squish&.downcase
      last_val = @raw_text[/#{keys.last}(.*?)(.*)/m, 2]

      @record[last_key] = last_val unless @record.has_key?(last_key)
      @record["available"] = true if @raw_text.match?(/domain not found|no entries found|not found|no match /i)
    end

    def val_by_regexp(regexp)
      searched_key = @record.keys.find { |key| key.to_s.match(regexp) }
      @record[searched_key]
    end

    def convert_date_to_utc(date)
      return nil unless date

      if date.match?(/^[0-9]{4}-[0-9]{2}-[0-9]{2}$/)
        date
      else
        Time.iso8601(date).to_s
      end
    rescue ArgumentError
      nil
    end
  end
end
