RSpec::Matchers.define :have_key do |key|
  chain :== do |value|
    @value = value
  end

  match do |hash|
    @has_key = hash.has_key?(key)

    if @value
      @has_key && hash[key] == @value
    else
      @has_key
    end
  end

  failure_message_for_should do |hash|
    if @value
      "#{hash.inspect} should have key #{key.inspect} == #{value.inspect}"
    else
      "#{hash.inspect} should have key #{key.inspect}"
    end
  end

  failure_message_for_should_not do |model|
    if @value
      "#{hash.inspect} should not have key #{key.inspect} == #{value.inspect}"
    else
      "#{hash.inspect} should not have key #{key.inspect}"
    end
  end
end
