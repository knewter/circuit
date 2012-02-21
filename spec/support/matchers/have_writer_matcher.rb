# http://solnic.eu/2011/01/14/custom-rspec-2-matchers.html
RSpec::Matchers.define :have_writer do |attribute|
  match do |model|
    model.respond_to?("#{attribute}=")
  end

  failure_message_for_should do |model|
    if @message
      "Validation errors #{model.errors[attribute].inspect} should include #{@message.inspect}"
    else
      "#{model.class} should have attribute writer #{attribute.inspect}"
    end
  end

  failure_message_for_should_not do |model|
    "#{model.class} should not have attribute writer #{attribute.inspect}"
  end
end
