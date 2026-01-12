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

    describe 'starts_at validations' do
      context 'on create' do
        it 'allows future dates' do
          event = build(:event, starts_at: 1.day.from_now)
          expect(event).to be_valid
        end

        it 'rejects past dates' do
          event = build(:event, starts_at: 1.day.ago)
          expect(event).not_to be_valid
          expect(event.errors[:starts_at]).to include('must be in the future')
        end

        it 'allows dates very close to current time' do
          event = build(:event, starts_at: 1.second.from_now)
          expect(event).to be_valid
        end
      end

      context 'on update' do
        it 'allows updating a future event to another future date' do
          event = create(:event, starts_at: 2.days.from_now)
          event.starts_at = 3.days.from_now
          expect(event).to be_valid
        end

        it 'allows updating a past event (for corrections)' do
          # Create event, then simulate time passing
          event = create(:event, starts_at: 2.days.from_now)
          allow(Time).to receive(:current).and_return(3.days.from_now)

          event.title = "Updated Title"
          expect(event).to be_valid
        end

        it 'prevents moving a future event to the past' do
          event = create(:event, starts_at: 2.days.from_now)
          event.starts_at = 1.day.ago
          expect(event).not_to be_valid
          expect(event.errors[:starts_at]).to include('cannot be changed to a past date')
        end
      end
    end
  end

  describe 'default values' do
    it 'sets public to false by default' do
      event = Event.new(group: create(:group), creator: create(:user), title: "Test", starts_at: 1.day.from_now)
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

    describe '.by_start_date' do
      it 'orders events by start date with nearest events first' do
        older_event = create(:event, starts_at: 2.days.from_now)
        newer_event = create(:event, starts_at: 5.days.from_now)
        oldest_event = create(:event, starts_at: 1.day.from_now)

        ordered_events = Event.by_start_date

        expect(ordered_events.first).to eq(oldest_event)
        expect(ordered_events.second).to eq(older_event)
        expect(ordered_events.third).to eq(newer_event)
      end
    end
  end
end
