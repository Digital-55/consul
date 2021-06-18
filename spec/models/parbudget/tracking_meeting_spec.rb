require "rails_helper"

describe Parbudget::TrackingMeeting do

  let(:track) { build(:parbudget_tracking_meeting) }

  describe "validations" do

    it "is valid" do
      expect(track).to be_valid
    end

  end

 
end
