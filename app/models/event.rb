class Event < ApplicationRecord
  belongs_to :group
  belongs_to :creator, class_name: "User"

  validates :title, presence: true
  validates :starts_at, presence: true

  scope :public_events, -> { where(public: true) }
  scope :by_start_date, -> { order(starts_at: :asc) }
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
