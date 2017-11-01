FactoryGirl.define do
  factory :classroom do
    name "Foo"
    zooniverse_group_id "1"
    join_token "asdf"
    program

    association :program, factory: :program

    trait :deleted do
      deleted_at { Time.now }
    end
  end
end
