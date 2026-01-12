require 'rails_helper'

RSpec.describe Event, type: :model do
  describe 'associations' do
    it { should belong_to(:group) }
    it { should belong_to(:creator).class_name('User') }
  end

  describe 'validations' do
    subject { build(:event) }

    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:starts_at) }
  end

  describe 'default values' do
    it 'sets public to false by default' do
      event = Event.new(group: create(:group), creator: create(:user), title: "Test", starts_at: Time.now)
      event.save!
      expect(event.public).to eq(false)
    end
  end
end
