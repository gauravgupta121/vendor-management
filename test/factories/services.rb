FactoryBot.define do
  factory :service do
    association :vendor
    sequence(:name) { |n| "Service #{n}" }
    start_date { Date.current }
    expiry_date { 1.year.from_now }
    payment_due_date { 1.month.from_now }
    amount { 5000.00 }
    status { "active" }

    # Status-based traits
    trait :active do
      status { "active" }
      expiry_date { 1.year.from_now }
    end

    trait :expired do
      status { "expired" }
      start_date { 1.year.ago }
      expiry_date { 1.day.ago }
      payment_due_date { 6.months.ago }
    end

    trait :payment_pending do
      status { "payment_pending" }
      start_date { 1.month.ago }
      payment_due_date { 5.days.ago }
    end

    trait :completed do
      status { "completed" }
      start_date { 1.year.ago }
      expiry_date { 6.months.ago }
      payment_due_date { 6.months.ago }
    end

    # Date-based traits (keeping for backward compatibility)
    trait :expiring_soon do
      expiry_date { 10.days.from_now }
    end

    trait :expiring_today do
      expiry_date { Date.current }
    end

    trait :expiring_in_3_days do
      expiry_date { 3.days.from_now }
    end

    trait :expiring_in_7_days do
      expiry_date { 7.days.from_now }
    end

    trait :expiring_in_15_days do
      expiry_date { 15.days.from_now }
    end

    trait :payment_due_soon do
      payment_due_date { 5.days.from_now }
    end

    trait :payment_due_today do
      payment_due_date { Date.current }
    end

  trait :payment_overdue do
    start_date { 1.year.ago }
    payment_due_date { 1.day.ago }
    expiry_date { 6.months.from_now }
  end

    trait :payment_due_in_3_days do
      payment_due_date { 3.days.from_now }
    end

    trait :payment_due_in_7_days do
      payment_due_date { 7.days.from_now }
    end

    trait :payment_due_in_15_days do
      payment_due_date { 15.days.from_now }
    end

    trait :with_high_amount do
      amount { 50000.00 }
    end

    trait :with_low_amount do
      amount { 100.00 }
    end

    trait :with_zero_amount do
      amount { 0.00 }
    end

    trait :without_amount do
      amount { nil }
    end

    trait :with_long_name do
      name { "A" * 1000 }
    end

    trait :with_special_characters do
      name { "Service & Co. (Special) Ltd." }
    end

    trait :with_unicode do
      name { "Sërvïcë 中文" }
    end

    trait :web_development do
      name { "Web Development" }
      amount { 10000.00 }
    end

    trait :mobile_app_development do
      name { "Mobile App Development" }
      amount { 15000.00 }
    end

    trait :cloud_hosting do
      name { "Cloud Hosting" }
      amount { 2000.00 }
    end

    trait :database_management do
      name { "Database Management" }
      amount { 8000.00 }
    end

    trait :security_services do
      name { "Security Services" }
      amount { 12000.00 }
    end

    trait :it_support do
      name { "IT Support" }
      amount { 5000.00 }
    end

    trait :network_infrastructure do
      name { "Network Infrastructure" }
      amount { 25000.00 }
    end

    trait :software_maintenance do
      name { "Software Maintenance" }
      amount { 3000.00 }
    end

    trait :data_analytics do
      name { "Data Analytics" }
      amount { 18000.00 }
    end

    trait :digital_marketing do
      name { "Digital Marketing" }
      amount { 7000.00 }
    end

    # Factory for creating service with invalid dates
    trait :with_invalid_dates do
      start_date { 1.year.from_now }
      expiry_date { 1.year.ago }
      payment_due_date { 2.years.ago }
    end

    # Factory for creating service with same start and expiry date
    trait :with_same_start_and_expiry do
      expiry_date { start_date }
    end

    # Factory for creating service with payment due before start
    trait :with_payment_due_before_start do
      payment_due_date { start_date - 1.day }
    end

    # Factory for creating service with very long duration
    trait :with_long_duration do
      start_date { 5.years.ago }
      expiry_date { 5.years.from_now }
    end

    # Factory for creating service with very short duration
    trait :with_short_duration do
      start_date { Date.current }
      expiry_date { 1.day.from_now }
    end

    # Factory for creating service with past start date
    trait :with_past_start_date do
      start_date { 1.year.ago }
      expiry_date { 6.months.from_now }
      payment_due_date { 11.months.ago }
    end

    # Factory for creating service with future start date
    trait :with_future_start_date do
      start_date { 1.month.from_now }
      expiry_date { 1.year.from_now }
      payment_due_date { 1.month.from_now }
    end
  end
end
