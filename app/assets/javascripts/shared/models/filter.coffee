class App.Model.Filter extends Backbone.Model
  defaults:
    service_types: [0, 1, 2, 3]

  setServiceType: (selected, value) ->
    value = parseInt(value)
    service_types = _.clone(@get('service_types'))
    if selected
      service_types.push(value) unless _.indexOf(service_types, value) >= 0
    else
      service_types.splice(index, 1)
    @set( service_types: service_types )

  match: (business)->
    _.include(@get('service_types'), business.get('service_type'))
