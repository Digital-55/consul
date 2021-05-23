require "rails_helper"

RSpec.describe Sg::Setting, type: :model do

  let(:sg_setting) { build(:sg_setting) }

  describe "validations" do
    it "should be valid" do
      expect(sg_setting).to be_valid
    end

    it "not should be valid title" do
      sg_setting.title = nil
      expect(sg_setting).not_to be_valid
    end

    it "not should be valid setting_type" do
      sg_setting.setting_type = nil
      expect(sg_setting).not_to be_valid
    end
   
  end
end
