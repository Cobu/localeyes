class EventVote
  include Mongoid::Document
  include Mongo::Voteable

  # set points for each vote
  voteable self, :up => +1, :down => -1

  #def self.votes_for_events(event_ids)
  #  $db.collection('votes').find({:event_id => {"$in"=>event_ids}}).each do
  #  end
  #end
end