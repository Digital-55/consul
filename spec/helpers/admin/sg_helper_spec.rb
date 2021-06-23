require "rails_helper"

describe Admin::SgHelper do
  describe "getters data" do
   
    it "get_filter_sg_tab" do
        expect(get_filter_sg_tab).not_to eq(nil)
    end

    it "get_header_tables_fields" do
        expect(get_header_tables_fields).not_to eq(nil)
    end

    it "get_header_select" do
        expect(get_header_select).not_to eq(nil)
    end

    it "get_tables" do
        expect(get_tables).not_to eq(nil)
    end

    it "get_fields_by_table(table_name)" do
        expect(get_fields_by_table("Vote")).not_to eq(nil)
    end

    it "get_sg_search_types_data" do
        expect(get_sg_search_types_data).not_to eq(nil)
    end

    it "get_sg_search_rules" do
        expect(get_sg_search_rules).not_to eq(nil)
    end

    it "get_sg_select(table_name, field_name)" do
        expect(get_sg_select("Budget::Investment", "feasibility")).not_to eq(nil)
        expect(get_sg_select("Budget", "phase")).not_to eq(nil)
        expect(get_sg_select("Budget", "currency_symbol")).not_to eq(nil)
        expect(get_sg_select("Sures::Actuation", "status")).not_to eq(nil)
        expect(get_sg_select("Sures::Actuation", "financig_performance")).not_to eq(nil)
        expect(get_sg_select("AdminNotification", "segment_recipient")).not_to eq(nil)
        expect(get_sg_select("Newsletter", "segment_recipient")).not_to eq(nil)
        expect(get_sg_select("Proposal", "proposal_type")).not_to eq(nil)
        expect(get_sg_select("Proposal", "proposal_reason")).not_to eq(nil)
        expect(get_sg_select("Legislation::Proposal", "proposal_type")).not_to eq(nil)
        expect(get_sg_select("Legislation::Proposal", "proposal_reason")).not_to eq(nil)
        expect(get_sg_select("Vote", "created_at")).to eq([])
        expect(get_sg_select(nil, nil)).to eq([])
    end
    
  end
end