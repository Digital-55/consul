require "rails_helper"

describe Parbudget::Responsible do

  let(:responsible) { build(:parbudget_responsible) }

  describe "validations" do

    it "is valid" do
      expect(responsible).to be_valid
    end

  end

  describe "methods" do
    it "get_columns" do
      expect(Parbudget::Responsible.get_columns).not_to eq(nil)
    end

    it "get_exporter" do
      expect(Parbudget::Responsible.get_exporter).not_to eq(nil)
    end

    it "center" do
      center = build(:parbudget_center)
      responsible.parbudget_center = center
      responsible.save
      expect(responsible.center).not_to eq(nil)
    end
  end
end
