require "rails_helper"

describe Parbudget::TrackInt do

  let(:track) { build(:parbudget_track_int) }

  describe "validations" do

    it "is valid" do
      expect(track).to be_valid
    end

  end

 
end
