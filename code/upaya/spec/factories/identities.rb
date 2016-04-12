FactoryGirl.define do
  factory :identity do
    service_provider 'https://upaya.serviceprovider.com'
  end

  trait :active do
    last_authenticated_at Time.zone.now
  end
end
