require "test_helper"

class ServiceTest < ActiveSupport::TestCase
  def setup
    @vendor = create(:vendor)
    @service = build(:service, vendor: @vendor)
  end

  # Association Tests
  test "should belong to vendor" do
    assert_respond_to @service, :vendor
    assert_equal :belongs_to, @service.class.reflect_on_association(:vendor).macro
  end

  # Validation Tests
  test "should be valid with valid attributes" do
    assert @service.valid?
  end

  test "name should be present" do
    @service.name = nil
    assert_not @service.valid?
    assert_includes @service.errors[:name], "can't be blank"
  end

  test "start_date should be present" do
    @service.start_date = nil
    assert_not @service.valid?
    assert_includes @service.errors[:start_date], "can't be blank"
  end

  test "expiry_date should be present" do
    @service.expiry_date = nil
    assert_not @service.valid?
    assert_includes @service.errors[:expiry_date], "can't be blank"
  end

  test "payment_due_date should be present" do
    @service.payment_due_date = nil
    assert_not @service.valid?
    assert_includes @service.errors[:payment_due_date], "can't be blank"
  end

  test "amount should be present and greater than 0" do
    @service.amount = nil
    assert_not @service.valid?
    assert_includes @service.errors[:amount], "can't be blank"

    @service.amount = 0
    assert_not @service.valid?
    assert_includes @service.errors[:amount], "must be greater than 0"
  end

  # Custom Validation Tests
  test "expiry_date should be after start_date" do
    @service.expiry_date = @service.start_date
    assert_not @service.valid?
    assert_includes @service.errors[:expiry_date], "must be after start date"
  end

  test "payment_due_date should be on or after start_date" do
    @service.payment_due_date = @service.start_date - 1.day
    assert_not @service.valid?
    assert_includes @service.errors[:payment_due_date], "must be on or after start date"
  end

  test "service name should be unique per vendor" do
    @service.save!

    duplicate_service = Service.new(
      vendor: @service.vendor,
      name: @service.name,
      start_date: Date.current,
      expiry_date: 1.year.from_now,
      payment_due_date: 1.month.from_now,
      amount: 3000.00
    )

    assert_not duplicate_service.valid?
    assert_includes duplicate_service.errors[:name], "must be unique per vendor"
  end

  test "service name should be unique per vendor with different vendors" do
    @service.save!

    different_vendor = create(:vendor)
    duplicate_service = build(:service, vendor: different_vendor, name: @service.name)

    assert duplicate_service.valid?
  end

  # Scope Tests
  test "active scope should return services with expiry_date >= current date" do
    active_service = create(:service, :expiring_soon)
    expired_service = create(:service, :expired)

    active_services = Service.active
    assert_includes active_services, active_service
    assert_not_includes active_services, expired_service
  end

  test "expired scope should return services with expiry_date < current date" do
    active_service = create(:service, :expiring_soon)
    expired_service = create(:service, :expired)

    expired_services = Service.expired
    assert_includes expired_services, expired_service
    assert_not_includes expired_services, active_service
  end

  test "payment_due scope should return services with payment_due_date <= current date" do
    due_service = create(:service, :payment_overdue)
    future_due_service = create(:service, :payment_due_soon)

    due_services = Service.payment_due
    assert_includes due_services, due_service
    assert_not_includes due_services, future_due_service
  end

  test "expiring_in scope should return services expiring within specified days" do
    expiring_service = create(:service, :expiring_in_15_days)
    past_service = create(:service, :expired)
    future_service = create(:service, :expiring_soon)

    expiring_services = Service.expiring_in(15)
    assert_includes expiring_services, expiring_service
    assert_not_includes expiring_services, past_service
    assert_includes expiring_services, future_service
  end

  # Integration Tests
  test "should create service with all valid attributes" do
    assert_difference "Service.count", 1 do
      @service.save!
    end
  end

  test "should not create service with invalid attributes" do
    @service.name = nil
    @service.amount = -100
    @service.expiry_date = @service.start_date

    assert_no_difference "Service.count" do
      @service.save
    end
  end
end
