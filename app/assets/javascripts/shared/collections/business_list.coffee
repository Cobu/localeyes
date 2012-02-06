class App.Collection.BusinessList extends Backbone.Collection
  model: App.Model.Business
  selected_id: null
  selected_view: null
  # override rest to clear the business markers in old collection before
  # the new collection takes its place
  reset: (collection)->
    @each((business)-> business.clearMarker())
    Backbone.Collection.prototype.reset.call(this, collection)

  clearSelected: ->
    this.get(@selected_id).setMarkerIcon() if @selected_id
    @selected_id = null
    @selected_view.close() if @selected_view
    @selected_view = null

  setSelected: (business_id, business_view)->
    # shrink icon
    @get(@selected_id).setMarkerIcon() if @selected_id
    # bigger icon
    @get(business_id).setMarkerIcon('large')
    @selected_id = business_id
    @selected_view = business_view
