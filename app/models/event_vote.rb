class EventVote
  include Mongoid::Document
  include Mongo::Voteable

  # set points for each vote
  voteable self, :up => +1, :down => -1

  scope :tally_fields, only('votes.down_count', 'votes.up_count', 'votes.point')
  scope :votes_for_event, -> event_id { where(_id: event_id).tally_fields }
  scope :votes_for_events, -> event_ids { any_in(_id: event_ids).tally_fields }

  def self.setup(id)
    collection.update(
      {'_id' => id},
      {'$set' => {'_id' => id, :votes => DEFAULT_VOTES}},
      {:upsert => true}
    )
  end
end