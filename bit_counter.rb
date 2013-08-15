# The machine is assumed to start on the most significant
# bit of the input number n. It will work until it gets stuck,
# at which point the tape head should be on the least significant
# bit of the output result k.
#
# Encoding is just numbers in binary.

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
  TMRule.new(0, '0', 0, 'X', :right),
  TMRule.new(0, '1', 4, 'X', :left),
  TMRule.new(1, '0', 4, 'X', :left),
  TMRule.new(1, '1', 4, 'X', :left),
  TMRule.new(1, 'X', 1, 'X', :right),
  TMRule.new(4, 'X', 4, 'X', :left),
  TMRule.new(4, '0', 6, '1', :right),
  TMRule.new(4, '1', 4, '0', :left),
  TMRule.new(4, '_', 6, '1', :right),
  TMRule.new(6, '0', 6, '0', :right),
  TMRule.new(6, '1', 6, '1', :right),
  TMRule.new(6, 'X', 1, 'X', :right),
])

class TestMachine < MiniTest::Unit::TestCase
  def build_machine(n)
    configuration = TMConfiguration.new(0, input_tape(n))
    accept_states = []
    DTM.new(configuration, accept_states, MACHINE_RULEBOOK)
  end

  def input_tape(n)
    head, *rest = n.to_s(2).chars
    tape = Tape.new([], head, rest, '_')
  end

  def run_machine(n)
    machine = build_machine(n)
    machine.run
    machine.current_configuration.tape.to_i
  end

  def test_machine
    assert_equal 0, run_machine(0), "f(0) should be 0"
    assert_equal 1, run_machine(1), "f(1) should be 1"

    (2..3).each do |n|
      assert_equal 2, run_machine(n), "f(#{n}) should be 2"
    end

    (4..7).each do |n|
      assert_equal 3, run_machine(n), "f(#{n}) should be 3"
    end

    (8..15).each do |n|
      assert_equal 4, run_machine(n), "f(#{n}) should be 4"
    end

    (16..31).each do |n|
      assert_equal 5, run_machine(n), "f(#{n}) should be 5"
    end

    (32..63).each do |n|
      assert_equal 6, run_machine(n), "f(#{n}) should be 6"
    end

    (64..127).each do |n|
      assert_equal 7, run_machine(n), "f(#{n}) should be 7"
    end

    (128..255).each do |n|
      assert_equal 8, run_machine(n), "f(#{n}) should be 8"
    end
  end
end

# >> Run options: --seed 3138
# >> 
# >> # Running tests:
# >> 
# >> .
# >> 
# >> Finished tests in 0.409080s, 2.4445 tests/s, 625.7945 assertions/s.
# >> 
# >> 1 tests, 256 assertions, 0 failures, 0 errors, 0 skips
