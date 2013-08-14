$: << File.expand_path('../', __FILE__)
require 'the_ultimate_machine'
require 'minitest/autorun'

class Tape
  def contents
    (left.join + middle + right.join).delete(blank)
  end

  def to_i
    contents.to_i(2)
  end
end

MACHINE_RULEBOOK = DTMRulebook.new([
  TMRule.new(1, '0', 1, '0', :right),
  TMRule.new(1, '1', 1, '1', :right),
  TMRule.new(1, '_', 2, '_', :left),
  TMRule.new(2, '0', 3, '_', :left),
  TMRule.new(2, '1', 3, '_', :left),
  TMRule.new(2, '_', 9, '_', :left),
  TMRule.new(3, '0', 3, '0', :left),
  TMRule.new(3, '1', 3, '1', :left),
  TMRule.new(3, '_', 4, '_', :left),
  TMRule.new(4, '0', 6, '1', :right),
  TMRule.new(4, '1', 5, '0', :left),
  TMRule.new(4, '_', 6, '1', :right),
  TMRule.new(5, '0', 6, '1', :right),
  TMRule.new(5, '1', 5, '0', :left),
  TMRule.new(5, '_', 6, '1', :right),
  TMRule.new(6, '0', 6, '0', :right),
  TMRule.new(6, '1', 6, '1', :right),
  TMRule.new(6, '_', 1, '_', :right),
])

class TestMachine < MiniTest::Unit::TestCase
  def build_machine(n)
    head, *rest = n.to_s(2).chars
    tape = Tape.new([], head, rest, '_')
    configuration = TMConfiguration.new(1, tape)
    accept_states = []
    DTM.new(configuration, accept_states, MACHINE_RULEBOOK)
  end

  def run_machine(n)
    machine = build_machine(n)
    machine.run
    machine.current_configuration.tape.to_i
  end

  def test_machine
    assert_equal 1, run_machine(0) # => true
    assert_equal 1, run_machine(1) # => true
    assert_equal 2, run_machine(2) # => true
    assert_equal 2, run_machine(3) # => true
    assert_equal 3, run_machine(4) # => true
    assert_equal 3, run_machine(5) # => true
    assert_equal 3, run_machine(6) # => true
    assert_equal 3, run_machine(7) # => true
    assert_equal 4, run_machine(8) # => true
    assert_equal 4, run_machine(9) # => true
    assert_equal 4, run_machine(10) # => true
    assert_equal 4, run_machine(11) # => true
    assert_equal 4, run_machine(12) # => true
    assert_equal 4, run_machine(13) # => true
    assert_equal 4, run_machine(14) # => true
    assert_equal 4, run_machine(15) # => true
    assert_equal 5, run_machine(16) # => true
    assert_equal 5, run_machine(17) # => true
    assert_equal 5, run_machine(18) # => true
    assert_equal 5, run_machine(19) # => true
    assert_equal 5, run_machine(20) # => true
    assert_equal 5, run_machine(21) # => true
    assert_equal 5, run_machine(22) # => true
    assert_equal 5, run_machine(23) # => true
    assert_equal 5, run_machine(24) # => true
    assert_equal 5, run_machine(25) # => true
    assert_equal 5, run_machine(26) # => true
    assert_equal 5, run_machine(27) # => true
    assert_equal 5, run_machine(28) # => true
    assert_equal 5, run_machine(29) # => true
    assert_equal 5, run_machine(30) # => true
    assert_equal 5, run_machine(31) # => true
    assert_equal 6, run_machine(32) # => true
  end
end

# >> Run options: --seed 24618
# >> 
# >> # Running tests:
# >> 
# >> .
# >> 
# >> Finished tests in 0.025067s, 39.8931 tests/s, 1316.4719 assertions/s.
# >> 
# >> 1 tests, 33 assertions, 0 failures, 0 errors, 0 skips
