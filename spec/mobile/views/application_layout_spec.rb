require "spec_helper"

RSpec.describe Mobile::Views::ApplicationLayout, type: :view do
  let(:layout) { Mobile::Views::ApplicationLayout.new({ format: :html }, "contents") }
  let(:rendered) { layout.render }

  it "contains application name" do
    expect(rendered).to include("getWHOIS")
  end
end
