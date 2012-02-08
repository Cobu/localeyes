class App.Model.Event extends Backbone.Model

  startDate: -> Date.parse( this.get('start') ).toString("yyyy-MM-dd")
  startHour: -> Date.parse( this.get('start') ).toString("h:mm")
  startAmPm: -> Date.parse( this.get('start') ).toString("tt")
  business: => window.consumer_events_view.business_list.get( @get('business_id') )
  businessName: -> @business().get('name')
  businessImageName: -> @business().imageName()
  businessIconName: -> @business().iconName()
  userFavoritePrefix: -> 'un' unless _.include( window.consumer_events_view.favorites.get('user_favorites'), @get('business_id') )








