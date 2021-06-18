require "rails_helper"

describe Parbudget::Media do

  let(:media) { build(:parbudget_media) }

  describe "validations" do

    it "is valid" do
      expect(media).to be_valid
    end

  end

  
end
