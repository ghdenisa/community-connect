class Group < ApplicationRecord
  validates :name, presence: true
end

# == Schema Information
#
# Table name: groups
#
#  id          :bigint           not null, primary key
#  description :text
#  name        :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
