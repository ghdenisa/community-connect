require 'rails_helper'

RSpec.describe TownSquareController, type: :request do
  describe 'GET /' do
    context 'when user is not authenticated' do
      it 'redirects to sign in page' do
        get root_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'when user is authenticated' do
      let(:user) { create(:user) }
      let(:public_event) {  create(:event, :public, title: "Public Community Event") }
      let(:private_event) { create(:event, title: "Private Group Event") }
      let(:older_event) { create(:event, :public, title: "Older Event", starts_at: 2.days.from_now) }
      let(:newer_event) { create(:event, :public, title: "Newer Event", starts_at: 5.days.from_now) }
      let(:oldest_event) { create(:event, :public, title: "Oldest Event", starts_at: 1.day.from_now) }

      before do
        sign_in user

        public_event
        private_event
        older_event
        newer_event
        oldest_event
      end

      it 'returns a successful response' do
        get root_path
        expect(response).to have_http_status(:success)
      end

      it 'displays only public events' do
        get root_path

        expect(response.body).to include("Public Community Event")
        expect(response.body).not_to include("Private Group Event")
      end

      it 'orders events with nearest events first' do
        get root_path

        oldest_position = response.body.index("Oldest Event")
        older_position = response.body.index("Older Event")
        newer_position = response.body.index("Newer Event")

        expect(oldest_position).to be < older_position
        expect(older_position).to be < newer_position
      end
    end
  end
end
