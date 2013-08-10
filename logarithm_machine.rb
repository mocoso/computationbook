$: << File.expand_path('../', __FILE__)
require 'the_ultimate_machine'
require 'minitest/autorun'

class ComparatorDesign < Struct.new(:input_1, :input_2, :accept_states)
  READ_INPUT_1 = Class.new
  READ_INPUT_2_0 = Class.new
  READ_INPUT_2_1 = Class.new
  INPUT_1_GREATER = Class.new
  INPUT_2_GREATER = Class.new
  EQUAL = Class.new

  def to_dtm
    DTM.new(configuration, accept_states, rulebook)
  end

  private

  def accept_states
    self[:accept_states].map { |s| self.class.const_get(s.to_s.upcase) }
  end

  def tape
    head, *rest = input_1.chars.zip(input_2.chars).flatten
    Tape.new([], head, rest, '_')
  end

  def start_state
    READ_INPUT_1
  end

  def configuration
    TMConfiguration.new(start_state, tape)
  end

  def rulebook
    DTMRulebook.new([
      TMRule.new(READ_INPUT_1, '0', READ_INPUT_2_0, '0', :right),
      TMRule.new(READ_INPUT_1, '1', READ_INPUT_2_1, '1', :right),
      TMRule.new(READ_INPUT_1, '_', EQUAL, '_', :left),
      TMRule.new(READ_INPUT_2_0, '0', READ_INPUT_1, '0', :right),
      TMRule.new(READ_INPUT_2_0, '1', INPUT_2_GREATER, '1', :right),
      TMRule.new(READ_INPUT_2_1, '0', INPUT_1_GREATER, '0', :right),
      TMRule.new(READ_INPUT_2_1, '1', READ_INPUT_1, '1', :right),
    ])
  end
end

class TestComparator < MiniTest::Unit::TestCase
  def comparator(input_1, input_2, accept_states)
    ComparatorDesign.new(input_1, input_2, accept_states).to_dtm
  end

  def test_first_input_greater
    dtm = comparator('111', '110', [:input_1_greater])

    dtm.run

    assert dtm.accepting? # => true
  end

  def test_second_input_greater
    dtm = comparator('110', '111', [:input_2_greater])

    dtm.run

    assert dtm.accepting? # => true
  end

  def test_inputs_are_equal
    dtm = comparator('111', '111', [:equal])

    dtm.run

    assert dtm.accepting? # => true
  end
end

# >> Run options: --seed 23441
# >> 
# >> # Running tests:
# >> 
# >> ...
# >> 
# >> Finished tests in 0.001554s, 1930.5019 tests/s, 1930.5019 assertions/s.
# >> 
# >> 3 tests, 3 assertions, 0 failures, 0 errors, 0 skips
