class EventVote
  include Mongoid::Document

  def self.votes_for_events(event_ids)
    $db.collection('votes').find({:event_id => {"$in"=>event_ids}}).each do
    end
  end
end