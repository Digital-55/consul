require "rails_helper"

describe Parbudget::Project do

  let(:project) { build(:parbudget_project) }

  describe "validations" do

    it "is valid" do
      expect(project).to be_valid
    end

  end

  describe "methods" do
    it "get_columns" do
      expect(Parbudget::Project.get_columns).not_to eq(nil)
    end

    it "get_exporter" do
      expect(Parbudget::Project.get_exporter).not_to eq(nil)
    end

    it "responsible" do
      responsible = build(:parbudget_responsible)
      project.parbudget_responsible = responsible
      project.save
      expect(project.responsible).not_to eq(nil)
    end

    it "ambit" do
      ambit = build(:parbudget_ambit)
      project.parbudget_ambit = ambit
      project.save
      expect(project.ambit).not_to eq(nil)
    end

    it "topic" do
      topic = build(:parbudget_topic)
      project.parbudget_topic = topic
      project.save
      expect(project.topic).not_to eq(nil)
    end


  end
end
