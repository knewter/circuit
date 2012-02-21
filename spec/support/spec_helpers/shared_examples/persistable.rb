require 'active_support/concern'

module SpecHelpers
  module SharedExamples
    module Persistable
      extend ActiveSupport::Concern
      included do

        shared_examples_for "persistable" do
          it { should be_valid                          }
          it { subject.save.should be_true              }
          it { ->{subject.save!}.should_not raise_error }
        end

      end
    end
  end
end
