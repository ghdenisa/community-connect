class EventCard::Component < ApplicationComponent
  option :event

  private

  def formatted_date
    event.starts_at.strftime("%A, %B %d at %l:%M %p")
  end

  def time_label
    time_diff = event.starts_at - Time.current

    if past_event?
      days_ago = (Time.current - event.starts_at) / 1.day
      if days_ago < 1
        "Ended today"
      elsif days_ago < 2
        "Ended yesterday"
      else
        "Ended #{days_ago.to_i} days ago"
      end
    else
      days_until = time_diff / 1.day
      if days_until < 1
        "Today"
      elsif days_until < 2
        "Tomorrow"
      else
        "Starts in #{days_until.to_i} days"
      end
    end
  end

  def truncated_description
    return "" if event.description.blank?
    event.description.truncate(150, separator: " ")
  end

  def past_event?
    event.starts_at < Time.current
  end

  def card_classes
    "opacity-60 grayscale" if past_event?
  end

  def badge_classes
    if past_event?
      "bg-gray-100 text-gray-700"
    else
      "bg-blue-100 text-blue-800"
    end
  end

  def can_edit?
    helpers.user_signed_in? && helpers.current_user == event.creator
  end
end
