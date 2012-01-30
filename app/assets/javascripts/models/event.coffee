class App.Model.Event extends Backbone.Model
  startDate: -> Date.parse( this.get('start') ).toString("yyyy-MM-dd")
  startHour: -> Date.parse( this.get('start') ).toString("h:mm")
  startAmPm: -> Date.parse( this.get('start') ).toString("tt")
  business: -> business_list.get( this.get('business_id') )
  businessName: -> this.business().get('name')
  businessImageName: -> this.business().imageName()
  businessIconName: -> this.business().iconName()
  userFavoritePrefix: -> 'un' unless _.include( Filter.userFavorites, this.get('business_id') )








