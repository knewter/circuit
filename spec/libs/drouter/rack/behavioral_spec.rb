require 'spec_helper'

describe Circuit::Rack::Behavioral do
  include Rack::Test::Methods
  include SpecHelpers::MultiSiteHelper

  class RenderMyMiddlewareBehavior
    include ::Circuit::Behavior

    use(Class.new do
      def initialize(app)
        @app = app
      end

      def call(env)
        [200, {"Content-Type" => "test/html"}, ["RenderMyMiddlewareBehavior"]]
      end
    end)
  end

  def app
    stub_app_with_circuit_site setup_site!('www.example.org', RenderMyMiddlewareBehavior)
  end

  context 'GET /' do
    get "/"

    context "status" do
      subject { last_response.body }
      it { should include("RenderMyMiddlewareBehavior") }
    end
  end

  context 'rewrite_env_with_behavior!' do
    let(:env)        { { 'PATH_INFO' => '/' } }
    let(:behavior)   { mock() }
    let(:behavioral) { Circuit::Rack::Behavioral.new('_') }
    subject { behavioral.rewrite_env_with_behavior! behavior, env }

    context ' when unset' do
      before do
        behavior.expects(:respond_to?).with(:rewrite_env_as!).once.returns(false)
        behavior.expects(:rewrite_env_as!).never
      end

      it { should == :rewrite_not_configured }
    end

    context 'rewrite_env_with_behavior!' do
      before do
        behavior.expects(:respond_to?).with(:rewrite_env_as!).once.returns(true)
        behavior.expects(:rewrite_env_as!).with(env).once
      end

      it { should == :rewritten }
    end

    context 'when raised ::Circuit::Behavior::RewriteException' do
      before do
        behavior.expects(:respond_to?).with(:rewrite_env_as!).once.returns(true)
        behavior.expects(:rewrite_env_as!).raises(::Circuit::Behavior::RewriteException)
      end

      it { should == :rewrite_failed }
    end

  end

  context 'GET / in rewrite' do
    class RewritePathInfoToFoobar
      include ::Circuit::Behavior

      def self.rewrite_env_as!(env)
        env['PATH_INFO'] = "/foobar"
      end
    end

    context 'GET /' do
      def app
        stub_app_with_circuit_site setup_site!('www.example.org', RewritePathInfoToFoobar)
      end

      context "example 1" do
        get "/"
        subject { last_response.body }
        it { should == "downstream /foobar" }
      end

      context "example 2" do
        get "/any-path-is-rewritten"
        subject { last_response.body }
        it { should == "downstream /foobar" }
      end

    end

  end
end
