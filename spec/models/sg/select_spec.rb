require "rails_helper"

RSpec.describe Sg::Select, type: :model do

  let(:sg_select) { build(:sg_select) }

  describe "validations" do
    it "should be valid" do
      expect(sg_select).to be_valid
    end

    it "not should be valid key" do
      sg_select.key = nil
      expect(sg_select).not_to be_valid
    end

    it "not should be valid setting" do
      sg_select.sg_setting = nil
      expect(sg_select).not_to be_valid
    end
   
  end
end
