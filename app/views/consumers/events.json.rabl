object false
node(:businesses) { @businesses }
node(:events) do
  EventDecorator.decorate(@events)
    .to_ary
    .collect { |e| e.consumer_events(@start_date, @end_date) }
    .flatten
end
node(:favorites) { current_user.try(:favorites) || [] }
node(:center) { @center.center_json }
node(:votes) do
  if current_user
    EventVote.votes_for_events(@events.collect { |e| e.id.to_i }.uniq)
  else
    []
  end
end
node(:in) { current_user.present? }
