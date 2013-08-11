$: << File.expand_path('../', __FILE__)
require 'the_ultimate_machine'
require 'minitest/autorun'

READ_INPUT_1 = Class.new
READ_INPUT_2_0 = Class.new
READ_INPUT_2_1 = Class.new
INPUT_1_GREATER = Class.new
INPUT_2_GREATER = Class.new
EQUAL = Class.new

COMPARATOR_RULEBOOK = DTMRulebook.new([
  TMRule.new(READ_INPUT_1, '0', READ_INPUT_2_0, '0', :right),
  TMRule.new(READ_INPUT_1, '1', READ_INPUT_2_1, '1', :right),
  TMRule.new(READ_INPUT_1, '_', EQUAL, '_', :left),
  TMRule.new(READ_INPUT_2_0, '0', READ_INPUT_1, '0', :right),
  TMRule.new(READ_INPUT_2_0, '1', INPUT_2_GREATER, '1', :right),
  TMRule.new(READ_INPUT_2_1, '0', INPUT_1_GREATER, '0', :right),
  TMRule.new(READ_INPUT_2_1, '1', READ_INPUT_1, '1', :right),
])

class TestComparator < MiniTest::Unit::TestCase
  def comparator(input_1, input_2, accept_states)
    head, *rest = input_1.chars.zip(input_2.chars).flatten
    tape = Tape.new([], head, rest, '_')
    configuration = TMConfiguration.new(READ_INPUT_1, tape)

    DTM.new(configuration, accept_states, COMPARATOR_RULEBOOK)
  end

  def test_first_input_greater
    dtm = comparator('111', '110', [INPUT_1_GREATER])

    dtm.run

    assert dtm.accepting? # => true
  end

  def test_second_input_greater
    dtm = comparator('110', '111', [INPUT_2_GREATER])

    dtm.run

    assert dtm.accepting? # => true
  end

  def test_inputs_are_equal
    dtm = comparator('111', '111', [EQUAL])

    dtm.run

    assert dtm.accepting? # => true
  end
end

# >> Run options: --seed 62072
# >> 
# >> # Running tests:
# >> 
# >> ...
# >> 
# >> Finished tests in 0.001457s, 2059.0254 tests/s, 2059.0254 assertions/s.
# >> 
# >> 3 tests, 3 assertions, 0 failures, 0 errors, 0 skips
