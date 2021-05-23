require "rails_helper"

RSpec.describe Sg::TableOrder, type: :model do

  let(:sg_table_order) { build(:sg_table_order) }

  describe "validations" do
    it "should be valid" do
      expect(sg_table_order).to be_valid
    end

    it "not should be valid order" do
      sg_table_order.order = -2
      expect(sg_table_order).not_to be_valid
    end

    it "not should be valid name" do
      sg_table_order.table_name = nil
      expect(sg_table_order).not_to be_valid
    end

    it "duplicated" do
      sg_table_order1 = create(:sg_table_order)
      sg_table_order2 = build(:sg_table_order)
      expect(sg_table_order2).not_to be_valid
    end
  end
end
