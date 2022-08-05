# This method ensures Minitest won't give us any deprecations
# regarding assert_nil when trying to use assert_equal.
def assert_equal_or_nil(*args)
  raise ArgumentError.new("Wrong number of arguments (given #{args.size}, expected 1..2)") if args.size > 2
  if args.size == 1
    assert_nil args.first
  elsif args.size == 2 && args.first.nil? # The first value should be the expected value.
    assert_nil args.last
  else
    assert_equal args.first, args.last
  end
end
