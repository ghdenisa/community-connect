class Event < ApplicationRecord
  belongs_to :group
  belongs_to :creator, class_name: "User"

  validates :title, presence: true
  validates :starts_at, presence: true

  validate :starts_at_must_be_in_future, on: :create
  validate :starts_at_cannot_be_moved_to_past, on: :update

  scope :public_events, -> { where(public: true) }
  scope :by_start_date, -> { order(starts_at: :asc) }

  private

  def starts_at_must_be_in_future
    return if starts_at.blank?

    if starts_at < Time.current
      errors.add(:starts_at, I18n.t("activerecord.errors.models.event.attributes.starts_at.must_be_future"))
    end
  end

  def starts_at_cannot_be_moved_to_past
    return if starts_at.blank?

    if starts_at_was && starts_at_was >= Time.current && starts_at < Time.current
      errors.add(:starts_at, I18n.t("activerecord.errors.models.event.attributes.starts_at.cannot_move_to_past"))
    end
  end
end

# == Schema Information
#
# Table name: events
#
#  id          :bigint           not null, primary key
#  description :text
#  public      :boolean          default(FALSE), not null
#  starts_at   :datetime         not null
#  title       :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  creator_id  :bigint           not null
#  group_id    :bigint           not null
#
# Indexes
#
#  index_events_on_creator_id  (creator_id)
#  index_events_on_group_id    (group_id)
#  index_events_on_public      (public)
#  index_events_on_starts_at   (starts_at)
#
# Foreign Keys
#
#  fk_rails_...  (creator_id => users.id)
#  fk_rails_...  (group_id => groups.id)
#
