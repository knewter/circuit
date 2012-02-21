require 'spec_helper'

describe Circuit::Site do

  let(:site) { Site.make }
  subject { site }

  it { should be_valid                              }
  it { should have_accessor(:parent)                }
  it { should have_accessor(:children)              }

  it { should validate_presence_of(:domain)         }
  it { should validate_presence_of(:behavior_klass) }

  context 'creation' do

    context 'with valid attributes' do
      subject { ->{ Site.make! } }
      it { should_not raise_error }

      context 'behavior accessor' do
        subject { site.behavior }
        it { should == Behaviors::RenderOK }
      end

      context 'behavior accessor' do
        before { site.behavior = Site }
        subject { site.behavior }
        it { should == Site }
      end

    end

    context 'invalid attributes' do
      let(:site) { Site.make domain: nil }
      it { should have_errors_on(:domain) }
    end

    context 'with capital letters in domain' do
      let(:site) { Site.make domain: '' }
      it { should have_errors_on(:domain).with_message("can't be blank") }
    end

    context 'with capital letters in domain' do
      let(:site) { Site.make domain: 'invalidDOMAIN.com' }
      it { should have_errors_on(:domain).with_message("is invalid") }
    end

    context 'with capital letters in domain' do
      let(:site) { Site.make domain: '!#$%@' }
      it { should have_errors_on(:domain).with_message("is invalid") }
    end

    context 'with ip address' do
      let(:site) { Site.make domain: '127.0.0.1' }
      it { should_not have_errors_on(:domain) }
    end

    context 'with nil behavior ' do
      let(:site) { Site.make behavior: nil }
      it { should have_errors_on(:behavior_klass) }
      it { subject.behavior.should be_nil }
    end

  end

  context 'naming' do
    subject { ->{ Site } }
    it { should_not raise_error }
  end

end
