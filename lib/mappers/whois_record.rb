# frozen_string_literal: true

# fproperties[] :#? rozen_string_literal: true# : nil,

require_relative 'parse_record'

module Mappers
  # base class with data structure
  class WhoisRecord
    def initialize(parser)
      @parser = parser
      @record_parser = ParseRecord.new(parser.part.body.to_s)
    end

    def call
      {
        disclaimer: disclaimer,
        domain: domain,
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
        raw_text: @parser.content.force_encoding('utf-8')
      }
    end

    private

    def disclaimer
      parser_respond_to?(:disclaimer) ? @parser.disclaimer : @record_parser.disclaimer
    end

    def domain
      parser_respond_to?(:domain) ? @parser.domain : @record_parser.domain
    end

    def domain_id
      parser_respond_to?(:domain_id) ? @parser.domain_id : @record_parser.domain_id
    end

    def status
      parser_respond_to?(:status) ? @parser.status : @record_parser.status
    end

    def available?
      parser_respond_to?(:available?) ? @parser.available? : @record_parser.available?
    end

    def registered?
      parser_respond_to?(:registered?) ? @parser.registered? : @record_parser.registered?
    end

    def created_on
      parser_respond_to?(:created_on) ? @parser.created_on : @record_parser.created_on
    end

    def updated_on
      parser_respond_to?(:updated_on) ? @parser.updated_on : @record_parser.updated_on
    end

    def expires_on
      parser_respond_to?(:expires_on) ? @parser.expires_on : @record_parser.expires_on
    end

    def registrar
      parser_respond_to?(:registrar) ? @parser.registrar.to_h : @record_parser.registrar
    end

    def registrant_contacts
      parser_respond_to?(:registrant_contact) ? @parser.registrant_contacts.map(&:to_h) : @record_parser.registrant_contacts
    end

    def admin_contacts
      parser_respond_to?(:admin_contacts) ? @parser.admin_contacts.map(&:to_h) : @record_parser.admin_contacts
    end

    def technical_contacts
      parser_respond_to?(:technical_contacts) ? @parser.technical_contacts.map(&:to_h) : @record_parser.technical_contacts
    end

    def nameservers
      parser_respond_to?(:nameservers) ? @parser.nameservers.map(&:to_h) : @record_parser.nameservers
    end

    def parser_respond_to?(method_name)
      @parser._properties[method_name] == :supported
    end
  end
end
