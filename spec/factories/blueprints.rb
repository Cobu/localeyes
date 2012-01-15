FactoryGirl.define do

  sequence(:email) { |n| "u#{n}@dude.com" }
  factory :user do
    email { FactoryGirl.generate(:email) }
    password { "moogoo" }
    birthday { Date.parse("1980-10-29") }

    factory :dude do
      email { "geucyd@gmail.com" }
      first_name { "Dude" }
      last_name { "Smiley" }
      phone { "5105551212" }
      password { "moogoo" }
    end
  end

  sequence(:business_user_email) { |n| "b#{n}@dude.com" }
  factory :business_user, parent: :dude, class: :business_user do
    email { FactoryGirl.generate(:business_user_email) }
  end

  now = Time.now.utc
  # keep the month changing over time
  $now_month = now.month
  blueprint_start_time = Time.utc(2011, now.month, 5, 7, 30)

  factory :business do
    name { 'Dans Diner' }
    association :user, :factory => :business_user
    phone { "6505551212" }
    address { '1 Dude street' }
    city { 'Oswego' }
    state { 'NY' }
    time_zone { "Pacific Time (US & Canada)" }
    zip_code { "13126" }
  end

  factory :oswego_restaurant, parent: :business do
    service_type { Business::RESTAURANT }
    name { "Law Library Deli" }
    description { "Eating here is probably legal. No funny business allowed" }
    address { "25 East Oneida Street" }
    lat { 43.456888 }
    lng { -76.505652 }
  end

  factory :oswego_cafe, parent: :business do
    service_type { Business::CAFE }
    name { "Public Library Cafe" }
    description { "Free food for all. It's public" }
    address { "120 East 2nd Street" }
    lat { 43.457044 }
    lng { -76.506187 }
  end

  factory :event do
    event_type { Event::EVENT }
    title { 'say hi to rob and then go home' }
    description { "Description for #{title} goes here. There might be spontaneous scrabble game or a guitar jam" }
    start_time { blueprint_start_time }
    end_time { blueprint_start_time + 2.hours }

    factory(:once_event) { title 'one times' }
    factory(:daily_event) { recur_value "day" }
    factory(:weekly_event) { recur_value "week" }
    factory(:monthly_event) { recur_value "month" }
  end


  factory :oswego, class: :zip_code do
    zip_code { "13126" }
    city { "Oswego" }
    state { "New York" }
    state_short { "NY" }
    lat { 43.4552778 }
    lng { -76.5108333 }
  end

  factory :new_paltz, class: :zip_code do
    zip_code { "12561" }
    city { "New Paltz" }
    state { "New York" }
    state_short { "NY" }
    lat { 41.758 }
    lng { -74.087 }
  end

  factory :ithaca, class: :zip_code do
    zip_code { "14850" }
    city { "Ithaca" }
    state { "New York" }
    state_short { "NY" }
    lat { 42.48 }
    lng { -76.47 }
  end


  factory :suny_oswego, class: :college do
    name { "SUNY College at Oswego" }
    address { "7060 State Route 104" }
    city { "Oswego" }
    state_short { "NY" }
    zip_code { "13126" }
    lat { 43.447299 }
    lng { -76.540587 }
  end

  factory :suny_new_paltz, class: :college do
    name { "SUNY College at New Paltz" }
    address { "1 Hawk Drive" }
    city { "New Paltz" }
    state_short { "NY" }
    zip_code { "12561" }
    lat { 41.738332 }
    lng { -74.090667 }
  end

  factory :cornell, class: :college do
    name { "Cornell University" }
    address { "300 Day Hall" }
    city { "Ithaca" }
    state_short { "NY" }
    zip_code { "14853" }
    lat { 42.445448 }
    lng { -76.482633 }
  end

  factory :ithaca_college, class: :college do
    name { "Ithaca College" }
    address { "953 Danby Rd" }
    city { "Ithaca" }
    state_short { "NY" }
    zip_code { "14850" }
    lat { 42.421081 }
    lng { -76.501278 }
  end
end
