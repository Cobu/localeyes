class window.Vote
  votes: []
  votes_hash: {}

  setVotes: (votes)->
    @votes = votes
    _.each(votes, (vote)=> @votes_hash[vote._id] = vote)

  show: ()-> _.each(@votes, (info)=> this.showNumbers(info))

  resetVotes: (data)->
    @votes_hash[data._id] = data
    _.each(@votes, (info, index)=>
        if (info._id == data._id)
          @votes[index] = data
          this.showNumbers(data)
    )
    window.event_list.sort() if window.sorter.sort_type == 'popular'

  showNumbers: (info)->
    elem = $(".event[data-id='#{info._id}']")
    elem.find(".vote.up .number").html(info.votes["up_count"] || 0)
    elem.find(".vote.down .number").html(info.votes["down_count"] || 0)

window.votes = new window.Vote()


class window.Sort
  sort_type: 'recent'
  sorts:
    recent: (event)-> event.get('start')
    popular: (event)-> - window.votes.votes_hash[event.id].votes['point']
    business: (event)-> event.businessName()

  setSortType: (type)->
    @sort_type = type
    window.event_list.comparator = this.sorts[type]
    window.event_list.sort()

window.sorter = new window.Sort()

