RSpec.describe Web::Controllers::Home::Show, type: :action do
  let(:action) { described_class.new }
  let(:params) { Hash[] }

  it "is successful" do
    response = action.call(params)
    expect(response[0]).to eq 301
  end
end