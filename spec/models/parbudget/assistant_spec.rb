require "rails_helper"

RSpec.describe Parbudget::Assistant, type: :model do

  let(:assistant) { build(:parbudget_assistant) }

  describe "validations" do
    it "is valid" do
      expect(assistant).to be_valid
    end
  end
end
