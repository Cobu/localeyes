require 'sham'

Sham.bemail { |index| "b#{index}@dude.com" }
Sham.uemail { |index| "u#{index}@dude.com" }

User.blueprint {
  email { Sham.uemail }
  password { "moogoo" }
}

User.blueprint(:dude) {
  email { "geucyd@gmail.com" }
  first_name { "Dude" }
  last_name { "Smiley" }
  phone { "5105551212" }
  password { "moogoo" }
}

BusinessUser.blueprint {
  email { Sham.bemail }
  first_name { "Dude" }
  last_name { "Smiley" }
  phone { "5105551212" }
  password { "moogoo" }
}

now = Time.now.utc
# keep the month changing with advancing time
$now_month = now.month
blueprint_start_time = Time.utc(2011, now.month, 5, 7, 30)

Business.blueprint {
  user
  phone { "6505551212" }
  address { '1 Dude street' }
  city { 'Oswego' }
  state { 'NY' }
  time_zone { "Pacific Time (US & Canada)" }
  zip_code { "13126" }
}

Business.blueprint(:oswego_restaurant) {
  service_type { Business::RESTAURANT }
  name { "Dudes Deli" }
  address { "840 Main Street" }
}

Business.blueprint(:oswego_cafe) {
  service_type { Business::CAFE }
  name { "Chads Cafe" }
  address { "841 Main Street" }
}


Event.blueprint {
  event_type { 0 }
  title { 'say hi to rob and then go home' }
  description { title }
  start_time { blueprint_start_time }
  end_time { blueprint_start_time + 2.hours }
}

Event.blueprint(:once) {
  title { 'one times' }
}

Event.blueprint(:daily) {
  recur_value { "day" }
}

Event.blueprint(:weekly) {
  recur_value { "week" }
}

Event.blueprint(:monthly) {
  recur_value { "month" }
}


ZipCode.blueprint {}
ZipCode.blueprint(:oswego) {
  zip_code { "13126" }
  city { "Oswego" }
  state { "New York" }
  state_short { "NY" }
  lat { 43.4654 }
  lng { -76.3422 }
}

ZipCode.blueprint(:new_paltz) {
  zip_code { "12561" }
  city { "New Paltz" }
  state { "New York" }
  state_short { "NY" }
  lat { 41.7464 }
  lng { -74.1092 }
}

College.blueprint {}
College.blueprint(:suny_oswego) {
  name { "SUNY College at Oswego" }
  address { "7060 State Route 104" }
  city { "Oswego" }
  state_short { "NY" }
  zip_code { "13126" }
}

College.blueprint(:suny_new_paltz) {
  name { "SUNY College at New Paltz" }
  address { "1 Hawk Drive" }
  city { "New Paltz" }
  state_short { "NY" }
  zip_code { "12561" }
}