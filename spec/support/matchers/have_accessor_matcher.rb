RSpec::Matchers.define :have_accessor do |attribute|
  match do |model|
    model.respond_to?(attribute) and model.respond_to?("#{attribute}=")
  end

  failure_message_for_should do |model|
    "#{model.class} should have attribute accessor #{attribute.inspect}"
  end

  failure_message_for_should_not do |model|
    "#{model.class} should not have attribute accessor #{attribute.inspect}"
  end
end
