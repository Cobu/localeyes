jasmine.Backbone = {}

((namespace) ->
  data =
    spiedEvents: {}
    handlers: []

  namespace.events =
    spyOn: (obj, eventName) ->
      handler = ->
        data.spiedEvents[[obj, eventName]] = arguments

      obj.bind eventName, handler

      data.handlers.push handler

    wasTriggered: (obj, eventName) ->
      !!(data.spiedEvents[[obj, eventName]])

    getTriggeredData: (obj, eventName) ->
      data.spiedEvents[[obj, eventName]]

    cleanUp: ->
      data.spiedEvents = {}
      data.handlers = []
)(jasmine.Backbone)

this.spyOnObjectEvent = (selector, eventName) ->
  jasmine.Backbone.events.spyOn(selector, eventName)


beforeEach ->
  this.addMatchers
    toHaveBeenTriggeredOnObj: (obj) ->
      this.message = ->
        [
          "Expected event " + this.actual + " not to have been triggered on " + obj
          "Expected event " + this.actual + " to have been triggered on " + obj,
        ]

      jasmine.Backbone.events.wasTriggered obj, this.actual

    toNotHaveBeenTriggeredOnObj: (obj) ->
      this.message = ->
        [
          "Expected event " + this.actual + " not to have been triggered on " + obj
          "Expected event " + this.actual + " to have been triggered on " + obj,
        ]

      !jasmine.Backbone.events.wasTriggered(obj, this.actual)

