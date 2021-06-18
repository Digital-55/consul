require "rails_helper"

describe Parbudget::Link do

  let(:link) { build(:parbudget_link) }

  describe "validations" do

    it "is valid" do
      expect(link).to be_valid
    end

  end

  
end
