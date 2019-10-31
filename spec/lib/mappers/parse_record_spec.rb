# frozen_string_literal: true

RSpec.describe Mappers::ParseRecord, :aggregate_failures do
  def read_file(name)
    File.read("spec/support/response_examples/#{name}.domain").gsub('\\r\\n', "\r\n").gsub('\\n', "\n")
  end

  it "accepts empty string" do
    parser = described_class.new("")
    expect(parser.domain).to be_nil
  end

  it "parses .news" do
    parser = described_class.new(read_file("news"))
    expect(parser.domain).to eq("xco.news")
    expect(parser.domain_id).to eq("f9b7895db33c453c8e372fc0ebd9cca5-DONUTS")
    expect(parser.status).to eq("registered")
    expect(parser.created_on).to eq("2017-04-11 15:03:23 UTC")
    expect(parser.updated_on).to eq("2019-04-14 22:39:10 UTC")
    expect(parser.expires_on).to eq("2020-04-11 15:03:23 UTC")
    expect(parser.registrar).to eq(
      id: "463",
      name: "Regional Network Information Center, JSC dba RU-CENTER",
      organization: "Regional Network Information Center, JSC dba RU-CENTER",
      url: "https://www.nic.ru/en/"
    )
    expect(parser.registrant_contacts).to include(
      id: "REDACTED FOR PRIVACY",
      type: 1,
      name: "REDACTED FOR PRIVACY",
      organization: "Privacy protection service - whoisproxy.ru",
      address: "REDACTED FOR PRIVACY",
      city: "REDACTED FOR PRIVACY",
      zip: "REDACTED FOR PRIVACY",
      state: "Moscow",
      country: "RU",
      country_code: nil,
      phone: "REDACTED FOR PRIVACY",
      fax: "REDACTED FOR PRIVACY",
      email: "Please query the RDDS service of the Registrar of Record identified in this output for information on how to contact the Registrant, Admin, or Tech contact of the queried domain name.",
      url: nil,
      created_on: nil,
      updated_on: nil
    )
    expect(parser.admin_contacts).to include(
      id: "REDACTED FOR PRIVACY",
      type: 2,
      name: "REDACTED FOR PRIVACY",
      organization: "REDACTED FOR PRIVACY",
      address: "REDACTED FOR PRIVACY",
      city: "REDACTED FOR PRIVACY",
      zip: "REDACTED FOR PRIVACY",
      state: "REDACTED FOR PRIVACY",
      country: "REDACTED FOR PRIVACY",
      country_code: nil,
      phone: "REDACTED FOR PRIVACY",
      fax: "REDACTED FOR PRIVACY",
      email: "Please query the RDDS service of the Registrar of Record identified in this output for information on how to contact the Registrant, Admin, or Tech contact of the queried domain name.",
      url: nil,
      created_on: nil,
      updated_on: nil
    )
    expect(parser.technical_contacts).to include(
      id: "REDACTED FOR PRIVACY",
      type: 3,
      name: "REDACTED FOR PRIVACY",
      organization: "REDACTED FOR PRIVACY",
      address: "REDACTED FOR PRIVACY",
      city: "REDACTED FOR PRIVACY",
      zip: "REDACTED FOR PRIVACY",
      state: "REDACTED FOR PRIVACY",
      country: "REDACTED FOR PRIVACY",
      country_code: nil,
      phone: "REDACTED FOR PRIVACY",
      fax: "REDACTED FOR PRIVACY",
      email: "Please query the RDDS service of the Registrar of Record identified in this output for information on how to contact the Registrant, Admin, or Tech contact of the queried domain name.",
      url: nil,
      created_on: nil,
      updated_on: nil
    )

    expect(parser.raw_text).to start_with("Domain Name: xco.news")
  end
end
