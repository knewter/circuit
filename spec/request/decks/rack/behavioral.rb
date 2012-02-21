require 'spec_helper'
require 'circuit'

describe Circuit::Rack::BehaviorProxy do
  it { ->{subject}.should_not raise_error }
end
