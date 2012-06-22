Data = {
  createBusiness: function(start_time) {
    var end_time = new Date(start_time).add({hours: 1})
    return {
      businesses: Business.cafe.toJSON(),
      events: [
        {
          id: '2',
          title: 'whole day fiesta',
          description: 'Description for whole day fiesta goes here. There might be spontaneous scrabble game or a guitar jam',
          start: start_time,
          end: end_time,
          business_id: 3,
          service_type: 'event_type'
        }
      ]
    }
  }
}