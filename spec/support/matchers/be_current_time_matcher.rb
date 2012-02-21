RSpec::Matchers.define :be_current_time do
  match do |time|
    # the to is is for rounding errors
    time.try(:utc).to_i == Time.zone.now.utc.to_i
  end

  failure_message_for_should do |time|
    "#{time.class} should be set to local time"
  end

  failure_message_for_should_not do |time|
    "#{time.class} should not be set to local time"
  end
end
