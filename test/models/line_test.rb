require 'test_helper'

class LineTest < ActiveSupport::TestCase
  setup do
    @line = lines(:valid)
  end

  test 'Validation: valid line' do
    assert @line.valid?
  end

  test 'Validation: invalid without electricity_metric' do
    @line.electricity_metric = nil
    refute @line.valid?
    assert_not_nil @line.errors[:electricity_metric]
  end

  test 'Validation: invalid without water_metric' do
    @line.water_metric = nil
    refute @line.valid?
    assert_not_nil @line.errors[:water_metric]
  end
  
  test 'Validation: invalid without apply date' do
    @line.applies_on = nil
    refute @line.valid?
    assert_not_nil @line.errors[:applies_on]
  end
end
