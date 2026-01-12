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

  describe 'scopes' do
    describe '.public_events' do
      it 'returns only public events' do
        public_event = create(:event, :public)
        private_event = create(:event)

        expect(Event.public_events).to include(public_event)
        expect(Event.public_events).not_to include(private_event)
      end
    end

    describe '.ordered_by_start_desc' do
      it 'orders events by start date with nearest events first' do
        older_event = create(:event, starts_at: 2.days.from_now)
        newer_event = create(:event, starts_at: 5.days.from_now)
        oldest_event = create(:event, starts_at: 1.day.from_now)

        ordered_events = Event.ordered_by_start_desc

        expect(ordered_events.first).to eq(oldest_event)
        expect(ordered_events.second).to eq(older_event)
        expect(ordered_events.third).to eq(newer_event)
      end
    end
  end
end
