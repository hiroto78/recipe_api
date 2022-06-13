FactoryBot.define do
  factory :recipe do
    title { 'Super Onigiri' }
    description { 'This is the best Onigiri ever.' }
    process { 'This is the process of cooking.' }
    ingredient do
      [{ item: 'rice', value: '10', unit: 'kg' },
       { item: 'tuna', value: '5', unit: 'kg' }].to_json
    end
    deleted_at { nil }
  end
end
