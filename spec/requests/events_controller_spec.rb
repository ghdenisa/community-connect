require 'rails_helper'

RSpec.describe EventsController, type: :request do
  let(:user) { create(:user) }
  let(:group) { create(:group) }

  describe 'GET /groups/:group_id/events/new' do
    context 'when user is not authenticated' do
      it 'redirects to sign in page' do
        get new_group_event_path(group)
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'when user is authenticated' do
      before { sign_in user }

      it 'returns a successful response' do
        get new_group_event_path(group)
        expect(response).to have_http_status(:success)
      end

      it 'displays the new event form' do
        get new_group_event_path(group)
        expect(response.body).to include("Create New Event")
      end
    end
  end

  describe 'POST /groups/:group_id/events' do
    context 'when user is not authenticated' do
      it 'redirects to sign in page' do
        post group_events_path(group), params: { event: { title: "Test Event" } }
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'when user is authenticated' do
      before { sign_in user }

      context 'with valid parameters' do
        let(:valid_params) do
          {
            event: {
              title: "Community Meetup",
              description: "A great meetup",
              starts_at: 2.days.from_now,
              public: true
            }
          }
        end

        it 'creates a new event' do
          expect {
            post group_events_path(group), params: valid_params
          }.to change(Event, :count).by(1)
        end

        it 'sets the creator to current user' do
          post group_events_path(group), params: valid_params
          expect(Event.last.creator).to eq(user)
        end

        it 'associates the event with the group' do
          post group_events_path(group), params: valid_params
          expect(Event.last.group).to eq(group)
        end

        it 'redirects to the group page' do
          post group_events_path(group), params: valid_params
          expect(response).to redirect_to(group_path(group))
        end

        it 'sets a success flash message' do
          post group_events_path(group), params: valid_params
          expect(flash[:notice]).to be_present
        end
      end

      context 'with invalid parameters' do
        let(:invalid_params) do
          {
            event: {
              title: "",
              description: "Missing title",
              starts_at: nil
            }
          }
        end

        it 'does not create a new event' do
          expect {
            post group_events_path(group), params: invalid_params
          }.not_to change(Event, :count)
        end

        it 'renders the new template' do
          post group_events_path(group), params: invalid_params
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end
  end

  describe 'GET /groups/:group_id/events/:id/edit' do
    let(:event) { create(:event, group: group, creator: user) }

    context 'when user is not authenticated' do
      it 'redirects to sign in page' do
        get edit_group_event_path(group, event)
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'when user is authenticated' do
      before { sign_in user }

      it 'returns a successful response' do
        get edit_group_event_path(group, event)
        expect(response).to have_http_status(:success)
      end

      it 'displays the edit event form' do
        get edit_group_event_path(group, event)
        expect(response.body).to include("Edit Event")
        expect(response.body).to include(event.title)
      end
    end
  end

  describe 'PATCH /groups/:group_id/events/:id' do
    let(:event) { create(:event, group: group, creator: user, title: "Original Title") }

    context 'when user is not authenticated' do
      it 'redirects to sign in page' do
        patch group_event_path(group, event), params: { event: { title: "Updated Title" } }
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'when user is authenticated' do
      before { sign_in user }

      context 'with valid parameters' do
        let(:valid_params) do
          {
            event: {
              title: "Updated Title",
              description: "Updated description",
              public: false
            }
          }
        end

        it 'updates the event' do
          patch group_event_path(group, event), params: valid_params
          event.reload
          expect(event.title).to eq("Updated Title")
          expect(event.description).to eq("Updated description")
          expect(event.public).to be false
        end

        it 'redirects to the group page' do
          patch group_event_path(group, event), params: valid_params
          expect(response).to redirect_to(group_path(group))
        end

        it 'sets a success flash message' do
          patch group_event_path(group, event), params: valid_params
          expect(flash[:notice]).to be_present
        end
      end

      context 'with invalid parameters' do
        let(:invalid_params) do
          {
            event: {
              title: "",
              starts_at: nil
            }
          }
        end

        it 'does not update the event' do
          patch group_event_path(group, event), params: invalid_params
          event.reload
          expect(event.title).to eq("Original Title")
        end

        it 'renders the edit template' do
          patch group_event_path(group, event), params: invalid_params
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end
  end

  describe 'authorization' do
    let(:creator) { create(:user) }
    let(:other_user) { create(:user) }
    let(:event) { create(:event, group: group, creator: creator) }

    describe 'GET /groups/:group_id/events/:id/edit' do
      context 'when user is not the event creator' do
        before { sign_in other_user }

        it 'redirects to group page' do
          get edit_group_event_path(group, event)
          expect(response).to redirect_to(group_path(group))
        end

        it 'sets an alert flash message' do
          get edit_group_event_path(group, event)
          expect(flash[:alert]).to eq('You can only edit events that you created.')
        end
      end

      context 'when user is the event creator' do
        before { sign_in creator }

        it 'allows access to edit page' do
          get edit_group_event_path(group, event)
          expect(response).to have_http_status(:success)
        end
      end
    end

    describe 'PATCH /groups/:group_id/events/:id' do
      context 'when user is not the event creator' do
        before { sign_in other_user }

        it 'redirects to group page' do
          patch group_event_path(group, event), params: {
            event: { title: "Hacked Title" }
          }
          expect(response).to redirect_to(group_path(group))
        end

        it 'does not update the event' do
          patch group_event_path(group, event), params: {
            event: { title: "Hacked Title" }
          }
          event.reload
          expect(event.title).not_to eq("Hacked Title")
        end

        it 'sets an alert flash message' do
          patch group_event_path(group, event), params: {
            event: { title: "Hacked Title" }
          }
          expect(flash[:alert]).to eq('You can only edit events that you created.')
        end
      end

      context 'when user is the event creator' do
        before { sign_in creator }

        it 'allows updating the event' do
          patch group_event_path(group, event), params: {
            event: { title: "Updated by Creator" }
          }
          event.reload
          expect(event.title).to eq("Updated by Creator")
        end
      end
    end
  end
end
