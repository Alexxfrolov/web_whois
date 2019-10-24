RSpec.describe Web::Controllers::Home::Index, type: :action do
  let(:action) { described_class.new }
  let(:params) { Hash[] }

  it "redirects without user-agent" do
    response = action.call(params)
    expect(response[0]).to eq 301
  end
end
