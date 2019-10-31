# frozen_string_literal: true

# fproperties[] :#? rozen_string_literal: true# : nil,

require_relative "parse_record"

module Mappers
  # base class with data structure
  class WhoisRecord
    def initialize(parser)
      @parser = parser
      @record_parser = ParseRecord.new(parser.content.to_s)
    end

    def call
      {
        disclaimer: disclaimer,
        domain: domain&.downcase,
        domain_id: domain_id,
        status: status,
        available: available?,
        registered: registered?,
        created_on: created_on,
        updated_on: updated_on,
        expires_on: expires_on,
        registrar: registrar,
        registrant_contacts: registrant_contacts,
        admin_contacts: admin_contacts,
        technical_contacts: technical_contacts,
        nameservers: nameservers,
        raw_text: @record_parser.raw_text
      }
    end

    private

    def disclaimer
      return nil if available?
      get_value(:disclaimer)
    end

    def domain
      return nil if available?
      get_value(:domain)
    end

    def domain_id
      return nil if available?
      get_value(:domain_id)
    end

    def status
      @record_parser.status
    end

    def available?
      @available ||= get_value(:available?)
    end

    def registered?
      get_value(:registered?)
    end

    def created_on
      get_value(:created_on)
    end

    def updated_on
      get_value(:updated_on)
    end

    def expires_on
      get_value(:expires_on)
    end

    def registrar
      return nil if available?
      parser_respond_to?(:registrar) ? @parser.registrar.to_h : @record_parser.registrar
    end

    def registrant_contacts
      return [] if available?
      parser_respond_to?(:registrant_contact) && @parser.registrant_contacts.present ? @parser.registrant_contacts.map(&:to_h) :
        @record_parser.registrant_contacts
    end

    def admin_contacts
      return [] if available?
      parser_respond_to?(:admin_contacts) && @parser.admin_contacts.present? ? @parser.admin_contacts.map(&:to_h) :
        @record_parser.admin_contacts
    end

    def technical_contacts
      return [] if available?
      parser_respond_to?(:technical_contacts) && @parser.technical_contacts.present? ? @parser.technical_contacts.map(&:to_h) :
        @record_parser.technical_contacts
    end

    def nameservers
      parser_respond_to?(:nameservers) ? @parser.nameservers.map(&:to_h) :
        @record_parser.nameservers
    end

    def parser_respond_to?(method_name)
      @parser._properties[method_name] == :supported && @parser.public_send(method_name).present?

    rescue Whois::ParserError
      false
    end

    def get_value(method)
      if parser_respond_to?(method)
        @parser.public_send(method).presence || @record_parser.public_send(method)
      else
        @record_parser.public_send(method)
      end
    end
  end
end
