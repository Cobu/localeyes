require 'spec_helper'

describe "Business Events" do

  let(:user) { BusinessUser.make! }
  let(:business) { Business.make!(:oswego_restaurant, :user=>user) }
  let(:once_event) {Event.make!(:once, :start_time=>Time.now.utc.change(:min=>15), :end_time=>Time.now+1.hour, :business=> business)}
  let(:daily_event) {Event.make!(:daily, :start_time=>Time.now.utc.change(:min=>15), :end_time=>Time.now+1.hour, :business=> business)}

  before { login_business_user user }

  describe "edits" do

    it "a one time event", :js=>true do
      start_time = Time.now.utc.change(:hour=>1, :min=>15, :sec=>0)
      e = Event.make!(:once, :start_time=>start_time, :business=> business)

      visit business_path(business)

      find(:css, "a.fc-event").click

      new_start_time = Time.now.utc.change(:hour=>3, :min=>30, :sec=>0)
      new_title = Time.now.to_i.to_s

      within('.edit_event') do
        fill_in 'event_title', :with=> new_title
        select new_start_time.hour.to_s, :from => 'event_start_time_hour'
        select new_start_time.strftime("%M"), :from => 'event_start_time_minute'
        select new_start_time.strftime("%P"), :from => 'event_start_time_am_pm'
        click_on 'Update'
      end

      e.reload
      e.title.should == new_title
      e.start_time.should == new_start_time
    end

    it "a daily event", :js=>true do
      e = daily_event
      new_title = Time.now.to_i.to_s
      until_date = (Time.now + 1.day).to_date

      login_business_user user
      visit business_path(business)

      find(:css, "a.fc-event").click

      within('.edit_event') do
        fill_in 'event_title', :with=> new_title
        fill_in 'event_recur_until_date', :with => until_date.strftime("%m/%d/%Y")
        click_on 'Update'
      end

      within('.choices_radio') do
        find(:css , "input#edit_affects_all_series").click
      end
      sleep(0.5)

      e.reload
      e.title.should == new_title
      e.schedule.rrules.first.until_date.to_date.should == until_date
    end
  end

  describe "deletes" do

    it "a one time event", :js=>true do
      once_event

      login_business_user user
      visit business_path(business)

      find(:css, "a.fc-event").click

      within('.edit_event') do
        click_on 'Delete'
      end

      Event.count.should == 0
    end

    it "a daily event, just one day", :js=>true do
      e = daily_event

      login_business_user user
      visit business_path(business)

      find(:css, "a.fc-event").click

      within('.edit_event') do
        click_on 'Delete'
      end

      within('.choices_radio') do
        find(:css , "input#edit_affects_one").click
      end

      e.reload
      e.schedule.exdates.size.should == 1
    end

  end

  describe "creates" do

    let(:title) { Time.now.to_i.to_s }
    let(:start_time) { Time.now.utc.change(:hour=>3, :min=>15, :sec=>0) }
    let(:end_time) { Time.now.utc.change(:hour=>4, :min=>30, :sec=>0) }

    before do
      login_business_user user
      visit business_path(business)

      find(:css, "td.fc-day11").click

      within('.new_event') do
        fill_in 'event_title', :with=> title

        fill_in 'event_start_date', :with=> start_time.strftime("%m/%d/%Y")
        select start_time.hour.to_s, :from => 'event_start_time_hour'
        select start_time.strftime("%M"), :from => 'event_start_time_minute'
        select start_time.strftime("%P"), :from => 'event_start_time_am_pm'

        fill_in 'event_end_date', :with=> end_time.strftime("%m/%d/%Y")
        select end_time.hour.to_s, :from => 'event_end_time_hour'
        select end_time.strftime("%M"), :from => 'event_end_time_minute'
        select end_time.strftime("%P"), :from => 'event_end_time_am_pm'
      end
    end

    it "a new one day event", :js=>true do
      within('.new_event') do
        choose 'Once'
        click_on 'Create Event'
      end

      sleep(0.5)

      Event.count.should == 1
      e = Event.first
      e.schedule.should be_nil
      e.title.should == title
      e.start_time.should == start_time
      e.end_time.should == end_time
    end

    it "a new daily event", :js=>true do
      until_date = (start_time + 1.day).to_date

      within('.new_event') do
        choose 'Daily'
        fill_in 'event_recur_until_date', :with => until_date.strftime("%m/%d/%Y")
        click_on 'Create Event'
      end

      sleep(0.5)

      Event.count.should == 1
      e = Event.first
      e.schedule.should_not be_nil
      e.schedule.rrules.first.until_date.to_date.should == until_date
      e.title.should == title
      e.start_time.should == start_time
      e.end_time.should == end_time
    end

  end

end