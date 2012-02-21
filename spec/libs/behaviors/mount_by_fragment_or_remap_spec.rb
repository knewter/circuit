require 'spec_helper'

describe Behaviors::MountByFragmentOrRemap do
  include Rack::Test::Methods
  include SpecHelpers::MultiSiteHelper

  def behavior
    Behaviors::MountByFragmentOrRemap
  end

  def site
    setup_site!('www.example.org', behavior)
  end

  def app
    stub_app_with_circuit_site site
  end

  context 'GET /' do
    subject { last_response.body }
    get "/"

    context "status" do
      it { should == "downstream /" }
    end
  end

  context 'GET /test' do
    before do
      Site.any_instance.expects(:find_child_by_fragment).
        with("test").at_least_once.returns(route_lookup)

      get "/test"
    end

    subject { last_response.body }

    context "when found" do
      let(:route_lookup) { Route.make behavior: ::Behaviors::RenderOK }
      it { should == "ok" }
    end

    context "when not found" do
      let(:route_lookup) { nil }
      it { should == "downstream /test" }
    end
  end

end
