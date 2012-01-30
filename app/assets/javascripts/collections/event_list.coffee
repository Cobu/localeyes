class App.Collection.EventList extends Backbone.Collection
  url: '/consumers/events'
  model: App.Model.Event

  comparator: (event)-> event.get('start')

  reset: ( collection, logged_in ) ->
    @logged_in = logged_in
    Backbone.Collection.prototype.reset.call(this, collection)


