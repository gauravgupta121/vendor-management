FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "User #{n}" }
    sequence(:email) { |n| "user#{n}@example.com" }
    password { "password123" }
    password_confirmation { "password123" }

    trait :admin do
      name { "Admin User" }
      email { "admin@vendor-management.com" }
    end

    trait :with_long_name do
      name { "A" * 100 }
    end

    trait :with_special_characters do
      name { "José María O'Connor-Smith" }
    end

    trait :with_unicode do
      name { "Tëst Üsér 中文" }
    end
  end
end
