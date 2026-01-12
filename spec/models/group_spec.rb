require 'rails_helper'

RSpec.describe Group, type: :model do
  describe 'associations' do
    it { should have_many(:events).dependent(:destroy) }
  end

  describe 'validations' do
    subject { build(:group) }

    it { should validate_presence_of(:name) }
  end
end
