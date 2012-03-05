window.App =
  Controller: {}
  Model: {}
  Collection: {}
  View: {}
  Router: {}

  consumer_init: ->
    new App.Router.Consumer()
    @start()

  start: -> Backbone.history.start()

