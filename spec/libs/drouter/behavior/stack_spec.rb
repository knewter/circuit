require 'spec_helper'

describe Circuit::Behavior::Stack do
  let(:empty_stack) { Circuit::Behavior::Stack.new }
  let(:populated_stack) {
    Circuit::Behavior::Stack.new do |stack|
      stack.use "first object"
      stack.use "second object"
    end
  }
  it { should have_accessor(:objects) }

  context 'can be created' do
    subject { -> { Circuit::Behavior::Stack.new } }
    it { should_not raise_error }
  end

  context 'when empty' do
    subject { empty_stack }
    it { should be_empty }

    context '#size' do
      subject { empty_stack.size }
      it { should == 0 }
    end
  end

  context 'when not empty' do
    subject { populated_stack }
    it { should_not be_empty }
    it { should have(2).objects }

    context '#size' do
      subject { populated_stack.size }
      it { should == 2 }
    end
  end

  context "when dupicated" do
    subject { populated_stack.dup }

    it { should_not === populated_stack }
    it { should have(2).objects }
  end

  context "when inserting with `use`" do
    subject { populated_stack }
    before { populated_stack.use "third object" }

    it { should have(3).objects }

    context "last" do
      subject { populated_stack.last }

      it { should == "third object" }
    end
  end

  context "when inserting with `insert_after`" do
    context "at the end" do
      subject { populated_stack }
      before { populated_stack.insert_after "second object", "third object" }

      it { should have(3).objects }

      context "last" do
        subject { populated_stack.last }

        it { should == "third object" }
      end

    end

    context "in the middle" do
      subject { populated_stack }
      before { populated_stack.insert_after "first object", "third object" }

      it { should have(3).objects }

      context "last" do
        subject { populated_stack.objects }

        it { should == ["first object", "third object", "second object"] }
      end

    end

    context "missing example" do
      subject { -> { populated_stack.insert_after "missing object", "third object" } }
      it { should raise_error(Circuit::Behavior::Stack::NoSuchObjectError) }
    end

  end

  context "when inserting with `insert_before`" do
    context "at the end" do
      subject { populated_stack.objects }
      before { populated_stack.insert_before "second object", "third object" }

      it { should == ["first object", "third object", "second object"] }
    end

    context "at the beginning" do
      subject { populated_stack.objects }
      before { populated_stack.insert_before "first object", "third object" }

      it { should == ["third object", "first object", "second object"] }
    end

    context "missing example" do
      subject { -> { populated_stack.insert_before "missing object", "third object" } }
      it { should raise_error(Circuit::Behavior::Stack::NoSuchObjectError) }
    end

  end

  context "when inserting with `swap`" do
    context "example 1" do
      subject { populated_stack.objects }
      before { populated_stack.swap "second object", "third object" }

      it { should == ["first object", "third object"] }
    end

    context "example 2" do
      subject { populated_stack.objects }
      before { populated_stack.swap "first object", "third object" }

      it { should == ["third object", "second object"] }
    end

    context "missing example" do
      subject { -> { populated_stack.swap "missing object", "third object" } }
      it { should raise_error(Circuit::Behavior::Stack::NoSuchObjectError) }
    end

  end

  context "when deleting" do
    subject { populated_stack.objects }
    before { populated_stack.delete "second object" }

    it { should == ["first object"] }
  end

  context "when clearing" do
    subject { populated_stack.objects }
    before { populated_stack.clear }

    it { should be_empty }
  end

  context "each" do
    subject { populated_stack }

    it { should respond_to(:each) }

    context "calling" do
      subject { ->{ populated_stack.each { |obj| obj } } }
      it { should_not raise_error }
    end
  end

end
