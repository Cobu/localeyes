User.blueprint {
  email { "u#{sn}@dude.com" }
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
  email { "b#{sn}@dude.com" }
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
  name { 'Dans Diner'}
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
  name { "Law Library Deli" }
  description { "Eating here is probably legal. No funny business allowed" }
  address { "25 East Oneida Street" }
  lat { 43.456888 }
  lng { -76.505652 }
}

Business.blueprint(:oswego_cafe) {
  service_type { Business::CAFE }
  name { "Public Library Cafe" }
  description { "Free food for all. It's public" }
  address { "120 East 2nd Street" }
  lat { 43.457044 }
  lng { -76.506187 }
}


Event.blueprint {
  event_type { Event::EVENT }
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


ZipCode.blueprint(:oswego) {
  zip_code { "13126" }
  city { "Oswego" }
  state { "New York" }
  state_short { "NY" }
  lat { 43.4552778 }
  lng { -76.5108333 }
}

ZipCode.blueprint(:new_paltz) {
  zip_code { "12561" }
  city { "New Paltz" }
  state { "New York" }
  state_short { "NY" }
  lat { 41.758 }
  lng { -74.087 }
}

ZipCode.blueprint(:ithaca) {
  zip_code { "14853" }
  city { "Ithaca" }
  state { "New York" }
  state_short { "NY" }
  lat { 41.758 }
  lng { -74.087 }
}

College.blueprint(:suny_oswego) {
  name { "SUNY College at Oswego" }
  address { "7060 State Route 104" }
  city { "Oswego" }
  state_short { "NY" }
  zip_code { "13126" }
  lat { 43.447299 }
  lng { -76.540587 }
}

College.blueprint(:suny_new_paltz) {
  name { "SUNY College at New Paltz" }
  address { "1 Hawk Drive" }
  city { "New Paltz" }
  state_short { "NY" }
  zip_code { "12561" }
  lat { 41.738332 }
  lng { -74.090667 }
}

College.blueprint(:cornell) {
  name { "Cornell University" }
  address { "300 Day Hall" }
  city { "Ithaca" }
  state_short { "NY" }
  zip_code { "14853" }
  lat { 42.445448 }
  lng { -76.482633 }
}

College.blueprint(:ithaca) {
  name { "Ithaca College" }
  address { "953 Danby Rd" }
  city { "Ithaca" }
  state_short { "NY" }
  zip_code { "14850" }
  lat { 42.421081 }
  lng { -76.501278 }
}


#College.create(
#  name: "Cornell University",
#  address: "300 Day Hall",
#  city: "Ithaca",
#  state_short: "NY",
#  zip_code: "14853",
#  lat: 42.445448,
#  lng: -76.482633
#)
#
#College.create(
#  name: "Ithaca College",
#  address: "953 Danby Rd",
#  city: "Ithaca",
#  state_short: "NY",
#  zip_code: "14850",
#  lat: 42.421081,
#  lng: -76.501278
#)
