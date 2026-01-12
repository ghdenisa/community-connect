class GroupCard::Component < ApplicationComponent
  option :group

  private

  def events_count_text
    helpers.t("groups.index.events_count", count: group.events.count)
  end
end
