require "rails_helper"

describe Parbudget::EconomicBudget do

  let(:economic) { build(:parbudget_economic_budget) }

  describe "validations" do

    it "is valid" do
      expect(economic).to be_valid
    end

  end

  
end
