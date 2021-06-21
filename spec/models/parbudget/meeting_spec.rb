require "rails_helper"

describe Parbudget::Meeting do

  let(:meeting) { build(:parbudget_meeting) }

  describe "validations" do

    it "is valid" do
      expect(meeting).to be_valid
    end

  end

  describe "methods" do
    it "get_columns" do
      expect(Parbudget::Meeting.get_columns).not_to eq(nil)
    end

    it "get_exporter" do
      expect(Parbudget::Meeting.get_exporter).not_to eq(nil)
    end

    it "assistants" do
      assistant = build(:parbudget_assistant)
      assistant.parbudget_meeting = meeting
      meeting.parbudget_assistants << assistant
      assistant.save
      meeting.save
      expect(meeting.assistants).not_to eq(nil)
    end

    it "no assistants" do
      meeting.parbudget_assistants = []
      meeting.save
      expect(meeting.assistants).to eq("")
    end

    it "reason_export" do
      expect(meeting.reason_export).not_to eq("")
    end

    it "assistants_export" do
      assistant = build(:parbudget_assistant)
      assistant.parbudget_meeting = meeting
      meeting.parbudget_assistants << assistant
      assistant.save
      meeting.save
      expect(meeting.reason_export).not_to eq("")
    end

  end
end
