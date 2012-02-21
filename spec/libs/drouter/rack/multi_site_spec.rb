require 'spec_helper'

describe Circuit::Rack::MultiSite do
  include Rack::Test::Methods
  include SpecHelpers::MultiSiteHelper

  def app
    Rack::Builder.app do
      use Circuit::Rack::MultiSite
      run Proc.new {|env| [200, {}, ["ok"]] }
    end
  end

  context 'GET example.com' do
    before do
      setup_site! "example.com"
      get "http://example.com/"
    end

    context "status" do
      subject { last_response.status }
      it { should == 200 }
    end

  end

  context "GET baddomain.com" do

    context 'with default site' do
      before do
        setup_site! "example.com"
        get "http://baddomain.com/"
      end

      context "status" do
        subject { last_response.status }
        it { should == 301 }
      end

      context "location headers" do
        subject { last_response.headers['Location'] }
        it { should == "http://www.example.org" }
      end

    end

    context 'without default site' do
      before do
        Circuit.instance_variable_set("@default_host", nil)
        setup_site! "example.com"
        get "http://baddomain.com/"
      end

      after do
        Circuit.load_hosts! "spec/internal/config/circuit_hosts.yml"
      end

      context "status" do
        subject { last_response.status }
        it { should == 404 }
      end

      context "body" do
        subject { last_response.body }
        it { should == "not found" }
      end

    end

  end

end
