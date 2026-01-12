require 'rails_helper'

RSpec.describe GroupsController, type: :request do
  describe 'GET /groups' do
    context 'when user is not authenticated' do
      it 'redirects to sign in page' do
        get groups_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'when user is authenticated' do
      let(:user) { create(:user) }
      let!(:group1) { create(:group, name: "Tech Enthusiasts", created_at: 2.days.ago) }
      let!(:group2) { create(:group, name: "Book Club", created_at: 1.day.ago) }
      let!(:group3) { create(:group, name: "Fitness Group", created_at: 3.days.ago) }

      before do
        sign_in user
      end

      it 'returns a successful response' do
        get groups_path
        expect(response).to have_http_status(:success)
      end

      it 'displays all groups' do
        get groups_path

        expect(response.body).to include("Tech Enthusiasts")
        expect(response.body).to include("Book Club")
        expect(response.body).to include("Fitness Group")
      end

      it 'orders groups alphabetically by name' do
        get groups_path

        book_club_position = response.body.index("Book Club")
        fitness_position = response.body.index("Fitness Group")
        tech_position = response.body.index("Tech Enthusiasts")

        expect(book_club_position).to be < fitness_position
        expect(fitness_position).to be < tech_position
      end
    end
  end

  describe 'GET /groups/:id' do
    context 'when user is not authenticated' do
      let(:group) { create(:group) }

      it 'redirects to sign in page' do
        get group_path(group)
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'when user is authenticated' do
      let(:user) { create(:user) }
      let(:group) { create(:group, name: "Tech Enthusiasts") }
      let!(:event1) { create(:event, :public, group: group, title: "Event 1", starts_at: 2.days.from_now) }
      let!(:event2) { create(:event, :public, group: group, title: "Event 2", starts_at: 5.days.from_now) }
      let!(:other_group_event) { create(:event, :public, title: "Other Group Event") }

      before do
        sign_in user
      end

      it 'returns a successful response' do
        get group_path(group)
        expect(response).to have_http_status(:success)
      end

      it 'displays the group name and description' do
        get group_path(group)

        expect(response.body).to include("Tech Enthusiasts")
        expect(response.body).to include(group.description)
      end

      it 'displays only events from this group' do
        get group_path(group)

        expect(response.body).to include("Event 1")
        expect(response.body).to include("Event 2")
        expect(response.body).not_to include("Other Group Event")
      end

      it 'orders events with nearest events first' do
        get group_path(group)

        event1_position = response.body.index("Event 1")
        event2_position = response.body.index("Event 2")

        expect(event1_position).to be < event2_position
      end
    end
  end
end
