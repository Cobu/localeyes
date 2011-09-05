require 'spec_helper'

describe "Business Events" do

  before(:all) do
    @bu = BusinessUser.make
    @b = Business.make(:oswego_restaurant, :user=>@bu)
  end
  after(:all) { BusinessUser.destroy_all }
  after(:each) { Event.delete_all }

  def sign_in_user(user)
    ApplicationController.session_data = { :business_user_id=>user.id, :business_id=>@b.id }
  end

  let(:once_event) {Event.make(:once, :start_time=>Time.now, :end_time=>Time.now+1.hour, :business=> @b)}
  let(:daily_event) {Event.make(:daily, :start_time=>Time.now, :end_time=>Time.now+1.hour, :business=> @b)}

  describe "edits" do

    it "a one time event", :js=>true do
      start_time = Time.now.utc.change(:hour=>1, :min=>2, :sec=>0)
      e = Event.make(:once, :start_time=>start_time, :business=> @b)

      sign_in_user @bu
      visit business_path(@b)

      find(:css, "a.fc-event").click

      new_start_time = Time.now.utc.change(:hour=>3, :min=>4, :sec=>0)
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

      sign_in_user @bu
      visit business_path(@b)

      find(:css, "a.fc-event").click

      within('.edit_event') do
        fill_in 'event_title', :with=> new_title
        click_on 'Update'
      end

      within('.choices_radio') do
        find(:css , "input#edit_affects_all_series").click
      end

      e.reload
      e.title.should == new_title
    end
  end

  describe "deletes" do

    it "a one time event", :js=>true do
      once_event

      sign_in_user @bu
      visit business_path(@b)

      find(:css, "a.fc-event").click

      within('.edit_event') do
        click_on 'Delete'
      end

      Event.count.should == 0
    end

    it "a daily event, just one day", :js=>true do
      e = daily_event

      sign_in_user @bu
      visit business_path(@b)

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

    it "a new event", :js=>true do
      new_title = Time.now.to_i.to_s
      new_start_time = Time.now.utc.change(:hour=>3, :min=>4, :sec=>0)
      new_end_time = Time.now.utc.change(:hour=>4, :min=>5, :sec=>0)

      sign_in_user @bu
      visit business_path(@b)

      find(:css, "td.fc-day11").click

      within('.new_event') do
        fill_in 'event_title', :with=> new_title

        fill_in 'event_start_date', :with=> new_start_time.strftime("%m/%d/%Y")
        select new_start_time.hour.to_s, :from => 'event_start_time_hour'
        select new_start_time.strftime("%M"), :from => 'event_start_time_minute'
        select new_start_time.strftime("%P"), :from => 'event_start_time_am_pm'

        fill_in 'event_end_date', :with=> new_end_time.strftime("%m/%d/%Y")
        select new_end_time.hour.to_s, :from => 'event_end_time_hour'
        select new_end_time.strftime("%M"), :from => 'event_end_time_minute'
        select new_end_time.strftime("%P"), :from => 'event_end_time_am_pm'

        click_on 'Create Event'
      end

      Event.count.should == 1
      e = Event.first
      e.title.should == new_title
      e.start_time.should == new_start_time
      e.end_time.should == new_end_time
    end

  end

end