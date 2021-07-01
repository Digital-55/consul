require "rails_helper"

describe Parbudget::Center do

  let(:center) { build(:parbudget_center) }

  describe "validations" do

    it "is valid" do
      expect(center).to be_valid
    end

  end

  describe "methods" do

    it "get_columns" do
      expect(Parbudget::Center.get_columns).not_to eq(nil)
    end

    it "get_exporter" do
      expect(Parbudget::Center.get_exporter).not_to eq(nil)
    end

    it "get_list" do
      expect(center.get_list).not_to eq(nil)
    end

    it "project" do
      project = build(:parbudget_project)
      center.parbudget_project = project
      center.save
      expect(center.project).not_to eq(nil)
    end

  end

end
