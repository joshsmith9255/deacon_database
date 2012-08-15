FactoryGirl.define do
  factory :client do
    last_name "Tabrizi"
    first_name "Dan"
    gender "Male"
    ethnicity "Hispanic"
    marital_status "Single"
    address "101 North Dithridge Street"
    city "Pittsburgh"
    state "PA"
    zip "15213"
    phone { rand(10 ** 10).to_s.rjust(10,'0') }
    gov_assistance false
    is_employed true
    is_veteran false
    active true
  end
  
  factory :deacon do
    last_name "Glazer"
    first_name "Carl"
    email "cglazer@andrew.cmu.edu"
    phone { rand(10 ** 10).to_s.rjust(10,'0') }
    gender "Male"
    role "Deacon"
    active true
  end
  
  factory :assignment do
    association :client
    association :deacon
    start_date 1.year.ago.to_date
    end_date 1.month.ago.to_date
    exit_notes "Swell guy, glad to help him out."
  end
end