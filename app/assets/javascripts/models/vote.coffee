class App.Model.Vote
  votes: []
  votes_hash: {}

  constructor: (@event_container)->

  setVotes: (votes)->
    @votes = votes
    _.each(votes, (vote)=> @votes_hash[vote._id] = vote)

  show: ()-> _.each(@votes, (info)=> this.showNumbers(info))

  resetVotes: (data)->
    @votes_hash[data._id] = data
    _.each(@votes, (info, index) =>
        if (info._id == data._id)
          @votes[index] = data
          this.showNumbers(data)
    )
    @event_container.event_list.sort() if @event_container.sorter.sort_type == 'popular'

  showNumbers: (info)->
    elem = $(".event[data-id='#{info._id}']")
    elem.find(".vote.up .number").html(info.votes["up_count"] || 0)
    elem.find(".vote.down .number").html(info.votes["down_count"] || 0)




