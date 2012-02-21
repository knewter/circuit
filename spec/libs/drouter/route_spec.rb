require 'spec_helper'

describe Circuit::Tree do
  include SpecHelpers::SharedExamples::Persistable
  include SpecHelpers::BaseRoutes

  let(:route) { Route.make }
  subject { route }

  it { should be_valid                 }
  it { should have_accessor(:parent)   }
  it { should have_accessor(:children) }
  it { should respond_to(:find_child_by_fragment) }

  it { should validate_presence_of(:behavior_klass) }

  context 'creation' do

    context 'with valid attributes' do
      subject { ->{ Route.make! } }
      it { should_not raise_error }

      context 'behavior accessor' do
        subject { route.behavior }
        it { should == Behaviors::MountByFragmentOrRemap }
      end

      context 'behavior accessor' do
        before { route.behavior = Site }
        subject { route.behavior }
        it { should == Site }
      end

    end

  end

  context 'naming' do
    subject { ->{ Route } }
    it { should_not raise_error }
  end

  context 'class' do
    subject { Route }

    it { should have_field(:slug)                                   }
    it { should validate_presence_of(:slug)                         }
    it { should validate_uniqueness_of(:slug).scoped_to(:parent_id) }

    context 'ancestors' do
      subject { Route.ancestors }

      it { should include(Mongoid::Tree)            }
      it { should include(Mongoid::Tree::Ordering)  }
      it { should include(Mongoid::Tree::Traversal) }
    end
  end

  context "with children" do
    let(:parent_route) { route }
    let(:child_routes) {
      3.times.collect do |_|
        Route.make :parent => parent_route
      end
    }

    shared_examples_for "a routing tree with children" do
      it { subject.should be_persisted }

      it 'should set chidren and perserve order' do
        child_routes.each_with_index do |child, index|
          subject.children[index].should == child
        end
      end
    end

    context "set by array" do
      subject { parent_route }
      before do
        parent_route.save

        parent_route.children = child_routes
      end

      it_should_behave_like "persistable"
      it_should_behave_like "a routing tree with children"
    end

    context "set by push" do
      subject { parent_route }
      before  do
        parent_route.save

        child_routes.each do |child|
          parent_route.children << child
        end
      end

      it_should_behave_like "persistable"
      it_should_behave_like "a routing tree with children"
    end

  end

  context 'find_child_by_fragment' do
    it { should respond_to(:find_child_by_fragment) }
  end


  # it should ensure children get created
  # it should ensure that when parents are removed, children are nullified
  # it should touch the parent when a new child is created
  # it should not touch the grandparent, when a child is edited
end
