require 'spec_helper'

describe Circuit::Behavior do
  class BaseClass
    include Circuit::Behavior
    use "first block"
    use "second block"
  end

  class InheritedClass < BaseClass
    use "third block"
  end

  let(:base_class) { BaseClass }
  let(:inherited_class) { InheritedClass }
  subject { BaseClass }

  it { ->{Circuit::Behavior}.should_not raise_error }
  it { ->{ subject }.should_not raise_error }

  context 'is listed in ancestors' do
    subject { base_class.ancestors }
    it { should include Circuit::Behavior }
  end

  context 'is listed in inherited ancestors' do
    subject { inherited_class.ancestors }
    it { should include Circuit::Behavior }
  end

  context 'when mixed class is configured' do
    subject { base_class.stack.objects }
    it { should == ["first block", "second block"] }
  end

  context 'inherited stack is configured properly' do
    subject { inherited_class.stack.objects }
    it { should == ["first block", "second block", "third block"] }
  end


end
