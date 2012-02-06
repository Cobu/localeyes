class App.Collection.EventList extends Backbone.Collection
  url: '/consumers/events'
  model: App.Model.Event

  comparator: (event)-> event.get('start')

