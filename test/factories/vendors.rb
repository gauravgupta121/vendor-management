FactoryBot.define do
  factory :vendor do
    sequence(:name) { |n| "Company #{n}" }
    sequence(:spoc) { |n| "Contact Person #{n}" }
    sequence(:email) { |n| "contact#{n}@company#{n}.com" }
    sequence(:phone) { |n| "#{1000000000 + n}" }
    status { "active" }

    trait :inactive do
      status { "inactive" }
    end

    trait :with_whitespace_email do
      email { "  CONTACT@COMPANY.COM  " }
    end

    trait :with_formatted_phone do
      phone { "123-456-7890" }
    end

    trait :with_spaced_phone do
      phone { "123 456 7890" }
    end

    # Factory for creating vendor with services
    factory :vendor_with_services do
      transient do
        services_count { 3 }
      end

      after(:create) do |vendor, evaluator|
        create_list(:service, evaluator.services_count, vendor: vendor)
      end
    end

    # Factory for creating vendor with expiring services
    factory :vendor_with_expiring_services do
      transient do
        services_count { 2 }
      end

      after(:create) do |vendor, evaluator|
        create_list(:service, evaluator.services_count, :expiring_soon, vendor: vendor)
      end
    end

    # Factory for creating vendor with payment due services
    factory :vendor_with_payment_due_services do
      transient do
        services_count { 2 }
      end

      after(:create) do |vendor, evaluator|
        create_list(:service, evaluator.services_count, :payment_due_soon, vendor: vendor)
      end
    end
  end
end
