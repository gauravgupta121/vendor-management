require "test_helper"

class UserTest < ActiveSupport::TestCase
  def setup
    @user = build(:user)
  end

  # Password Security Tests
  test "should have secure password" do
    assert_respond_to @user, :password
    assert_respond_to @user, :password_confirmation
    assert_respond_to @user, :authenticate
  end

  test "should authenticate with correct password" do
    @user.save!
    assert @user.authenticate("password123")
  end

  test "should not authenticate with incorrect password" do
    @user.save!
    assert_not @user.authenticate("wrongpassword")
  end

  # Validation Tests
  test "should be valid with valid attributes" do
    assert @user.valid?
  end

  test "name should be present" do
    @user.name = nil
    assert_not @user.valid?
    assert_includes @user.errors[:name], "can't be blank"
  end

  test "name should have minimum length of 2" do
    @user.name = "A"
    assert_not @user.valid?
    assert_includes @user.errors[:name], "is too short (minimum is 2 characters)"
  end

  test "name should have maximum length of 100" do
    @user.name = "A" * 101
    assert_not @user.valid?
    assert_includes @user.errors[:name], "is too long (maximum is 100 characters)"
  end

  test "email should be present" do
    @user.email = nil
    assert_not @user.valid?
    assert_includes @user.errors[:email], "can't be blank"
  end

  test "email should have valid format" do
    @user.email = "invalid-email"
    assert_not @user.valid?
    assert_includes @user.errors[:email], "is invalid"
  end

  test "email should be unique" do
    @user.save!
    duplicate_user = build(:user, email: @user.email)
    assert_not duplicate_user.valid?
    assert_includes duplicate_user.errors[:email], "has already been taken"
  end

  test "email should be unique case insensitive" do
    @user.save!
    duplicate_user = build(:user, email: @user.email.upcase)
    assert_not duplicate_user.valid?
    assert_includes duplicate_user.errors[:email], "has already been taken"
  end

  test "password should be present on create" do
    @user.password = nil
    @user.password_confirmation = nil
    assert_not @user.valid?
    assert_includes @user.errors[:password], "can't be blank"
  end

  test "password should have minimum length of 6" do
    @user.password = "12345"
    @user.password_confirmation = "12345"
    assert_not @user.valid?
    assert_includes @user.errors[:password], "is too short (minimum is 6 characters)"
  end

  test "password and password_confirmation should match" do
    @user.password = "password123"
    @user.password_confirmation = "differentpassword"
    assert_not @user.valid?
    assert_includes @user.errors[:password_confirmation], "doesn't match Password"
  end

  # Callback Tests
  test "should normalize email before save" do
    @user.email = "  john@example.com  "
    @user.valid? # This triggers the callback
    assert_equal "john@example.com", @user.email
  end

  # Integration Tests
  test "should create user with all valid attributes" do
    assert_difference "User.count", 1 do
      @user.save!
    end
  end

  test "should not create user with invalid attributes" do
    @user.name = nil
    @user.email = "invalid-email"
    @user.password = "123"

    assert_no_difference "User.count" do
      @user.save
    end
  end

  test "should update user with valid attributes" do
    @user.save!
    @user.update!(name: "Updated Name", email: "updated@example.com")
    assert_equal "Updated Name", @user.name
    assert_equal "updated@example.com", @user.email
  end
end
