require "rails_helper"

describe Parbudget::TrackingInternal do

  let(:track) { build(:parbudget_tracking_internal) }

  describe "validations" do

    it "is valid" do
      expect(track).to be_valid
    end

  end

 
end
