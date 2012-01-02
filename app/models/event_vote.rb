class EventVote
  include Mongoid::Document
  include Mongo::Voteable

  # set points for each vote
  voteable self, :up => +1, :down => -1

  scope :votes_for_event, -> event_id { where(_id: event_id).only('votes.down_count', 'votes.up_count') }
  scope :votes_for_events, -> event_ids { any_in(_id: event_ids).only('votes.down_count', 'votes.up_count') }

  def self.past_vote(event_id, user_id)
    event_vote = where(_id: event_id).only('votes.down', 'votes.up').first
    return nil unless event_vote
    return 'up' if event_vote.votes.try(:[],'up').include? user_id
    return 'down' if event_vote.votes.try(:[],'down').include? user_id
    nil
  end
end