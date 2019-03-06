require 'test_helper'

class UserTest < ActiveSupport::TestCase
  setup do
    @user = users(:valid)
  end

  test 'Validation: valid user' do
    assert @user.valid?
  end

  test 'Validation: invalid without name' do
    @user.name = nil
    refute @user.valid?, 'user is valid without a name'
    assert_not_nil @user.errors[:name]
  end

  test 'Validation: invalid without email' do
    @user.email = nil
    refute @user.valid?
    assert_not_nil @user.errors[:email]
  end
end
