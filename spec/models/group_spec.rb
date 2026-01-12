require 'rails_helper'

RSpec.describe Group, type: :model do
  describe 'validations' do
    subject { build(:group) }

    it { should validate_presence_of(:name) }
  end
end
