require "rails_helper"

describe Parbudget::Topic do

  let(:topic) { build(:parbudget_topic) }

  describe "validations" do

    it "is valid" do
      expect(topic).to be_valid
    end

  end

  describe "methods" do
    it "get_columns" do
      expect(Parbudget::Topic.get_columns).not_to eq(nil)
    end
  end
end
