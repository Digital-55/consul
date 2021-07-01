require "rails_helper"

RSpec.describe Parbudget::Ambit, type: :model do

  let(:ambit) { build(:parbudget_ambit) }

  context "validations" do

    it "is valid" do
      expect(ambit).to be_valid
    end

  end

  describe "methods" do
    it "get_columns" do
      expect(Parbudget::Ambit.get_columns).not_to eq(nil)
    end
  end
end

