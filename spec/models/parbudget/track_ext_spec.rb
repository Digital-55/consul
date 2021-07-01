require "rails_helper"

describe Parbudget::TrackExt do

  let(:track) { build(:parbudget_track_ext) }

  describe "validations" do

    it "is valid" do
      expect(track).to be_valid
    end

  end

 
end
