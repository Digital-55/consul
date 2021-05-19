require "rails_helper"

RSpec.describe Sg::Generic, type: :model do

  let(:sg_generic) { build(:sg_generic) }

  describe "validations" do
    it "should be valid" do
      expect(sg_generic).to be_valid
    end

    it "not should be valid title" do
      sg_generic.title = nil
      expect(sg_generic).not_to be_valid
    end

    it "not should be valid generic_type" do
      sg_generic.generic_type = nil
      expect(sg_generic).not_to be_valid
    end
   
  end
end
