require "test_helper"

class VendorTest < ActiveSupport::TestCase
  def setup
    @vendor = build(:vendor)
  end

  # Association Tests
  test "should have many services" do
    assert_respond_to @vendor, :services
    assert_equal :has_many, @vendor.class.reflect_on_association(:services).macro
  end

  test "should destroy associated services when vendor is destroyed" do
    @vendor.save!
    create(:service, vendor: @vendor)

    assert_difference "Service.count", -1 do
      @vendor.destroy
    end
  end

  # Enum Tests
  test "should have status enum with active and inactive values" do
    assert_equal "active", Vendor.statuses["active"]
    assert_equal "inactive", Vendor.statuses["inactive"]
  end

  test "should default to active status" do
    vendor = create(:vendor)
    assert vendor.active?
    assert_equal "active", vendor.status
  end

  test "should be able to set status to inactive" do
    @vendor.status = "inactive"
    assert @vendor.inactive?
    assert_equal "inactive", @vendor.status
  end

  # Validation Tests
  test "should be valid with valid attributes" do
    assert @vendor.valid?
  end

  test "name should be present" do
    @vendor.name = nil
    assert_not @vendor.valid?
    assert_includes @vendor.errors[:name], "can't be blank"
  end

  test "spoc should be present" do
    @vendor.spoc = nil
    assert_not @vendor.valid?
    assert_includes @vendor.errors[:spoc], "can't be blank"
  end

  test "spoc should have minimum length of 2" do
    @vendor.spoc = "A"
    assert_not @vendor.valid?
    assert_includes @vendor.errors[:spoc], "is too short (minimum is 2 characters)"
  end

  test "spoc should have maximum length of 100" do
    @vendor.spoc = "A" * 101
    assert_not @vendor.valid?
    assert_includes @vendor.errors[:spoc], "is too long (maximum is 100 characters)"
  end

  test "email should be present" do
    @vendor.email = nil
    assert_not @vendor.valid?
    assert_includes @vendor.errors[:email], "can't be blank"
  end

  test "email should have valid format" do
    @vendor.email = "invalid-email"
    assert_not @vendor.valid?
    assert_includes @vendor.errors[:email], "is invalid"
  end

  test "email should be unique" do
    @vendor.save!
    duplicate_vendor = build(:vendor, email: @vendor.email)
    assert_not duplicate_vendor.valid?
    assert_includes duplicate_vendor.errors[:email], "has already been taken"
  end

  test "email should be unique case insensitive" do
    @vendor.save!
    duplicate_vendor = build(:vendor, email: @vendor.email.upcase)
    assert_not duplicate_vendor.valid?
    assert_includes duplicate_vendor.errors[:email], "has already been taken"
  end

  test "phone should be present" do
    @vendor.phone = nil
    assert_not @vendor.valid?
    assert_includes @vendor.errors[:phone], "can't be blank"
  end

  test "phone should be exactly 10 digits" do
    @vendor.phone = "123456789"
    assert_not @vendor.valid?
    assert_includes @vendor.errors[:phone], "is the wrong length (should be 10 characters)"
  end

  test "phone should contain only digits" do
    @vendor.phone = "123-456-7890"
    # Skip the normalization callback to test the validation directly
    @vendor.define_singleton_method(:normalize_phone) { }
    assert_not @vendor.valid?
    assert_includes @vendor.errors[:phone], "is invalid"
  end

  test "phone should be valid with 10 digits" do
    @vendor.phone = "1234567890"
    assert @vendor.valid?
  end

  # Callback Tests
  test "should normalize email before save" do
    @vendor.email = "  contact@techsolutions.com  "
    @vendor.valid? # This triggers the callback
    assert_equal "contact@techsolutions.com", @vendor.email
  end

  test "should normalize phone before save" do
    @vendor.phone = "123-456-7890"
    @vendor.valid? # This triggers the callback
    assert_equal "1234567890", @vendor.phone
  end

  # Integration Tests
  test "should create vendor with all valid attributes" do
    assert_difference "Vendor.count", 1 do
      @vendor.save!
    end
  end

  test "should not create vendor with invalid attributes" do
    @vendor.name = nil
    @vendor.email = "invalid-email"
    @vendor.phone = "123"

    assert_no_difference "Vendor.count" do
      @vendor.save
    end
  end

  test "should update vendor with valid attributes" do
    @vendor.save!
    @vendor.update!(name: "Updated Company", spoc: "Updated User")
    assert_equal "Updated Company", @vendor.name
    assert_equal "Updated User", @vendor.spoc
  end

  test "should not update vendor with invalid attributes" do
    @vendor.save!
    @vendor.update(name: nil, email: "invalid-email")
    assert_not @vendor.valid?
    assert_includes @vendor.errors[:name], "can't be blank"
    assert_includes @vendor.errors[:email], "is invalid"
  end
end
