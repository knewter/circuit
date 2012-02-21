RSpec::Matchers.define :have_instance_variable do |var_symbol|
  chain :== do |value|
    @value = value
  end

  match do |model|
    @ivar = model.instance_variable_get("@#{var_symbol.to_s}")

    if @value
      @ivar == @value
    else
      @ivar
    end
  end

  failure_message_for_should do |model|
    if @message
      "#{model.class} should have instance variable #{var_symbol.inspect} == #{value.inspect}"
    else
      "#{model.class} should have instance variable #{var_symbol.inspect}"
    end
  end

  failure_message_for_should_not do |model|
    if @message
      "#{model.class} should not have instance variable #{var_symbol.inspect} == #{value.inspect}"
    else
      "#{model.class} should not have instance variable #{var_symbol.inspect}"
    end

  end
end
