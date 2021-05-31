require "rails_helper"

RSpec.describe Sg::TableField, type: :model do

  let(:sg_table_field) { build(:sg_table_field) }

  describe "validations" do
    it "should be valid" do
      expect(sg_table_field).to be_valid
    end

    it "not should be valid table name" do
      sg_table_field.table_name = nil
      expect(sg_table_field).not_to be_valid
    end

    it "not should be valid field name" do
      sg_table_field.field_name = nil
      expect(sg_table_field).not_to be_valid
    end

    it "duplicated search" do
      sg_table_field1 = create(:sg_table_field)
      sg_table_field1.sgeneric = create(:sg_setting)
      sg_table_field1.save
      sg_table_field2 = build(:sg_table_field)
      sg_table_field2.sgeneric = sg_table_field1.sgeneric
      sg_table_field2.save
      expect(sg_table_field2).not_to be_valid
    end

    it "duplicated generic" do
      sg_table_field1 = create(:sg_table_field)
      sg_table_field1.sgeneric = create(:sg_generic)
      sg_table_field1.save
      sg_table_field2 = build(:sg_table_field)
      sg_table_field2.sgeneric = sg_table_field1.sgeneric
      sg_table_field2.save
      expect(sg_table_field2).not_to be_valid
    end

    it "not duplicated generic" do
      sg_table_field1 = create(:sg_table_field)
      sg_table_field1.sgeneric = create(:sg_generic)
      sg_table_field1.save
      sg_table_field2 = build(:sg_table_field)
      sg_table_field2.sgeneric = sg_table_field1.sgeneric
      sg_table_field2.field_name = "updated_at"
      sg_table_field2.save
      expect(sg_table_field2).to be_valid
    end

    it "not duplicated distinct" do
      sg_table_field1 = create(:sg_table_field)
      sg_table_field1.sgeneric = create(:sg_setting)
      sg_table_field1.save
      sg_table_field2 = build(:sg_table_field)
      sg_table_field2.sgeneric = create(:sg_generic)
      sg_table_field2.save
      expect(sg_table_field2).to be_valid
    end

    it "not duplicated search" do
      sg_table_field1 = create(:sg_table_field)
      sg_table_field1.sgeneric = create(:sg_setting)
      sg_table_field1.save
      sg_table_field2 = build(:sg_table_field)
      sg_table_field2.sgeneric = create(:sg_generic)
      sg_table_field2.field_name = "updated_at"
      sg_table_field2.save
      expect(sg_table_field2).to be_valid
    end


    it "duplicated order" do
      sg_table_field1 = create(:sg_table_field)
      sg_table_field1.sgeneric = create(:sg_setting)
      sg_table_field1.sgeneric.setting_type = "order"
      sg_table_field1.save
      sg_table_field2 = build(:sg_table_field)
      sg_table_field2.sgeneric = sg_table_field1.sgeneric
      sg_table_field2.field_name = "updated_at"
      sg_table_field2.save
      expect(sg_table_field2).not_to be_valid
    end

    it "not duplicated order" do
      sg_table_field1 = create(:sg_table_field)
      sg_table_field1.sgeneric = create(:sg_setting)
      sg_table_field1.sgeneric.setting_type = "order"
      sg_table_field1.save
      sg_table_field2 = build(:sg_table_field)
      sg_table_field2.sgeneric = sg_table_field1.sgeneric
      sg_table_field2.table_name = "Admin"
      sg_table_field2.save
      expect(sg_table_field2).to be_valid
    end

    it "not duplicated update" do
      sg_table_field1 = create(:sg_table_field)
      sg_table_field1.sgeneric = create(:sg_setting)
      sg_table_field1.sgeneric.setting_type = "order"
      sg_table_field1.save
      sg_table_field2 = sg_table_field1
      expect(sg_table_field2).to be_valid
    end
  end
end
