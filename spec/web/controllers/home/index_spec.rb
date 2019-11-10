RSpec.describe Web::Controllers::Home::Index, type: :action do
  let(:action) { described_class.new }
  let(:params) { Hash[] }

  it "returns 200" do
    response = action.call(params)
    expect(response[0]).to eq 200
  end

  it "redirects with requests" do
    user_agent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_6) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/12.1.2 Safari/605.1.15"
    response = action.call(request: "www.google.com", "HTTP_USER_AGENT" => user_agent)

    expect(response[0]).to eq 301
    expect(response[1]["Location"]).to eq "/google.com"
  end

  it "redirects with request param" do
    response = action.call(params.merge(request: "google.com"))
    expect(response[0]).to eq 301
  end
end
