class EventDecorator < PresenterBase

  def start_date
    start_time.strftime("%m/%d/%Y")
  end

  def start_time_hour
    start_time.strftime("%H")
  end

  def start_time_minute
    start_time.strftime("%M")
  end

  def start_time_am_pm
    start_time.strftime("%p")
  end

  def end_date
    end_time.strftime("%m/%d/%Y")
  end

  def end_time_hour
    end_time.strftime("%H")
  end

  def end_time_minute
    end_time.strftime("%M")
  end

  def end_time_am_pm
    end_time.strftime("%P")
  end
end