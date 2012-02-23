window.cafe_business = new App.Model.Business(
  id: 3,
  user_id: 2,
  name: "Public Library Cafe",
  service_type: 0,
  description: "Free food for all. It's public",
  time_zone: "Pacific Time (US & Canada)",
  address: "120 East 2nd Street",
  address2: null,
  city: "Oswego", state: "NY", zip_code: "13126",
  phone: "6505551212",
  hours: [
    {from: null, to: null, open: false},
    {from: '1970-01-01 09:00:00 UTC', to: '1970-01-01 17:00:00 UTC', open: true},
    {from: '1970-01-01 09:00:00 UTC', to: '1970-01-01 17:00:00 UTC', open: true},
    {from: '1970-01-01 09:00:00 UTC', to: '1970-01-01 17:00:00 UTC', open: true},
    {from: '1970-01-01 09:00:00 UTC', to: '1970-01-01 17:00:00 UTC', open: true},
    {from: '1970-01-01 09:00:00 UTC', to: '1970-01-01 17:00:00 UTC', open: true},
    {from: '1970-01-01 09:00:00 UTC', to: '1970-01-01 17:00:00 UTC', open: true},
  ],
  url: null, image: null,
  lat: 43.457, lng: -76.5062, geocoded_by: null,
  active: null
)

window.deli_business = new App.Model.Business(
  id: 4,
  user_id: 2,
  name: "Law Library Deli",
  service_type: 1,
  description: "Eating here is probably legal. No funny business al...",
  time_zone: "Pacific Time (US & Canada)",
  address: "25 East Oneida Street",
  address2: null, city: "Oswego", state: "NY",
  zip_code: "13126", phone: "6505551212",
  hours: [
    {from: null, to: null, open: false},
    {from: '1970-01-01 09:00:00 UTC', to: '1970-01-01 17:00:00 UTC', open: true},
    {from: '1970-01-01 09:00:00 UTC', to: '1970-01-01 17:00:00 UTC', open: true},
    {from: '1970-01-01 09:00:00 UTC', to: '1970-01-01 17:00:00 UTC', open: true},
    {from: '1970-01-01 09:00:00 UTC', to: '1970-01-01 17:00:00 UTC', open: true},
    {from: '1970-01-01 09:00:00 UTC', to: '1970-01-01 17:00:00 UTC', open: true},
    {from: '1970-01-01 09:00:00 UTC', to: '1970-01-01 17:00:00 UTC', open: true},
  ],
  url: null,
  image: null,
  lat: 43.4569, lng: -76.5057, geocoded_by: null,
  active: null
)


events: [
  {
    id: "2",
    title: "whole day fiesta",
    description: "Description for whole day fiesta goes here. There might be spontaneous scrabble game or a guitar jam",
    start: "2012-02-10 10:15:00",
    end: '2012-02-10 22:00:00 UTC',
    business_id: 3,
    service_type: "event_type"
  },

  {
    id: "2",
    title: "whole day fiesta",
    description: "Description for whole day fiesta goes here. There might be spontaneous scrabble game or a guitar jam",
    start: "2012-02-11 10:15:00",
    end: '2012-02-11 22:00:00 UTC',
    business_id: 3,
    service_type: "event_type"
  },
  {
    id: "2",
    title: "whole day fiesta",
    description: "Description for whole day fiesta goes here. There might be spontaneous scrabble game or a guitar jam",
    start: "2012-02-12 10:15:00",
    end: '2012-02-12 22:00:00 UTC',
    business_id: 3,
    service_type: "event_type"
  }
]

favorites: [2, 3]

center:
  title: "SUNY College at Oswego\nOswego, NY, 13126"
  lat: 43.4464
  lng: 76.5421

