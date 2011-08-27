require 'sham'

Sham.email { |index| "dude#{index}@dude.com" }

User.blueprint {
  email { Sham.email }
}

BusinessUser.blueprint {
  email { Sham.email }
  first_name { "Dude" }
  last_name { "Smiley" }
  phone { "5105551212" }
  password { "moogoo" }
}

now = Time.now.utc
blueprint_start_time = Time.utc(2011,now.month,5,7,30)

Business.blueprint {
  user
  phone { "5551212" }
  city { 'New York' }
  state { 'NY' }
  time_zone { "Pacific Time (US & Canada)" }
}

Business.blueprint(:nyc_restaurant) {
  service_type { Business::RESTAURANT }
  name { "Dudes Deli" }
  address { "840 Broadway" }
  zip_code { 10003 }
}

Business.blueprint(:nyc_cafe) {
  service_type { Business::CAFE }
  name { "Chads Cafe" }
  address { "841 Broadway" }
  zip_code { 10003 }
}


Event.blueprint {
  event_type { 0 }
  title { 'say hi to rob and then go home' }
  description { title }
  start_time { blueprint_start_time }
  end_time  { blueprint_start_time + 2.hours }
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