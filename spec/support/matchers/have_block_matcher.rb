RSpec::Matchers.define :have_block do |block_sym|
  match do |template|
    # the to is is for rounding errors
    template.blocks[block_sym]
  end

  failure_message_for_should do |template|
    "#{template.class} should have block(#{block_sym})"
  end

  failure_message_for_should_not do |template|
    "#{template.class} should not have block(#{block_sym})"
  end
end
