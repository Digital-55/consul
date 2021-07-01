require "rails_helper"

describe Parbudget::TrackingExternal do

  let(:track) { build(:parbudget_tracking_external) }

  describe "validations" do

    it "is valid" do
      expect(track).to be_valid
    end

  end

 
end
