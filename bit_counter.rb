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
  TMRule.new(0, '0', 0, '0', :right),
  TMRule.new(0, '1', 1, '1', :right),
  TMRule.new(0, '_', 7, '_', :left),
  TMRule.new(1, '0', 1, '0', :right),
  TMRule.new(1, '1', 1, '1', :right),
  TMRule.new(1, '_', 2, '_', :left),
  TMRule.new(2, '0', 3, '_', :left),
  TMRule.new(2, '1', 3, '_', :left),
  TMRule.new(2, '_', 7, '_', :left),
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
    configuration = TMConfiguration.new(0, tape)
    accept_states = [7]
    DTM.new(configuration, accept_states, MACHINE_RULEBOOK)
  end

  def run_machine(n)
    machine = build_machine(n)
    machine.run
    machine.current_configuration.tape.to_i
  end

  def test_machine
    assert_equal 0, run_machine(0), "k of 0 should be 0"
    assert_equal 1, run_machine(1), "k of 1 should be 1"

    (2..3).each do |n|
      assert_equal 2, run_machine(n), "k of #{n} should be 2"
    end

    (4..7).each do |n|
      assert_equal 3, run_machine(n), "k of #{n} should be 3"
    end

    (8..15).each do |n|
      assert_equal 4, run_machine(n), "k of #{n} should be 4"
    end

    (16..31).each do |n|
      assert_equal 5, run_machine(n), "k of #{n} should be 5"
    end

    (32..63).each do |n|
      assert_equal 6, run_machine(n), "k of #{n} should be 6"
    end

    (64..127).each do |n|
      assert_equal 7, run_machine(n), "k of #{n} should be 7"
    end

    (128..255).each do |n|
      assert_equal 8, run_machine(n), "k of #{n} should be 8"
    end
  end
end

# >> Run options: --seed 51261
# >> 
# >> # Running tests:
# >> 
# >> .
# >> 
# >> Finished tests in 0.399200s, 2.5050 tests/s, 641.2826 assertions/s.
# >> 
# >> 1 tests, 256 assertions, 0 failures, 0 errors, 0 skips
