# frozen_string_literal: true

RSpec.describe Mappers::WhoisRecord, :aggregate_failures do
  let(:parser) { Object.new }
  subject { described_class.new(parser) }

  def stub_with(name)
    body = read_file(name)
    parser.stub(:_properties).and_return({})
    parser.stub(:content).and_return(body)
  end

  def read_file(name)
    File.read("spec/support/response_examples/#{name}.domain")
        .gsub('\\r\\n', "\r\n")
        .gsub('\\n', "\n")
  end

  def response(name)
    data = File.read("spec/support/response_examples/#{name}.json")
    JSON.parse(data).deep_symbolize_keys!
  end

  it "parses .com" do
    stub_with("com")
    expect(subject.call).to include_json(response("com"))
  end

  it "parses .ru" do
    stub_with("ru")
    expect(subject.call).to include_json(response("ru"))
  end

  it "parses .io" do
    stub_with("io")
    expect(subject.call).to include_json(response("io"))
  end

  it "parses .news" do
    stub_with("news")
    expect(subject.call).to include_json(response("news"))
  end

  it "parses .org" do
    stub_with("org")
    expect(subject.call).to include_json(response("org"))
  end

  it "parses not_found" do
    stub_with("not_found")
    expect(subject.call).to include_json(response("not_found"))
  end
end
