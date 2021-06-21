require "rails_helper"

describe Admin::Parbudget::MeetingsController do
  before do
    @admin = create(:administrator)
    sign_in(@admin.user)
  end

  describe "GET index" do
    it "seach data" do
      create(:parbudget_meeting)
      get :index
      expect(response.status).to be(200)
    end

    it "seach data order asc" do
      create(:parbudget_meeting)
      get :index, params: {direction: "asc",sort_by: "date_at_convert"}
      expect(response.status).to be(200)
    end

    it "seach data order desc" do
      create(:parbudget_meeting)
      get :index, params: {direction: "asc",sort_by: "date_at_convert"}
      expect(response.status).to be(200)
    end

    it "export CSV" do
      create(:parbudget_meeting)
      get :index, params: {format: :csv}
      expect(response.status).to be(200)
    end

    it "search_date_start" do
      create(:parbudget_meeting)
      get :index,  params: {search_date_start: Time.zone.now}
      expect(response.status).to be(200)
    end

    it "search_date_end" do
      create(:parbudget_meeting)
      get :index,  params: {search_date_end: Time.zone.now}
      expect(response.status).to be(200)
    end

    it "search_date_start and search_date_end" do
      create(:parbudget_meeting)
      get :index,  params: {search_date_start: Time.zone.now,search_date_end: Time.zone.now}
      expect(response.status).to be(200)
    end

    it "subnav" do
      create(:parbudget_meeting)
      get :index,  params: {subnav: "pending"}
      expect(response.status).to be(200)
    end
  end

  describe "GET show_meeting" do
    it "show element" do
      meeting = create(:parbudget_meeting)
      get :show, params: {id: meeting.id}
      expect(response.status).to be(200)
    end

    it "export pdf" do
      meeting = create(:parbudget_meeting)
      get :show, params: {id: meeting.id, format: :pdf}
      expect(response.status).to be(200)
    end
  end

  describe "GET new_meeting" do
    it "new element" do
      get :new
      expect(response.status).to be(200)
    end
  end

  describe "GET edit_meeting" do
    it "edit element" do
      meeting = create(:parbudget_meeting)
      get :edit, params: {id: meeting.id}
      expect(response.status).to be(200)
    end
  end

  describe "POST create_meeting" do
    it "generate element" do
      meeting = build(:parbudget_meeting)
      post :create, params: {parbudget_meeting: meeting.attributes}
      expect(response.status).to be(302)
    end
  end

  describe "PUT update_meeting" do
    it "update element" do
      meeting = create(:parbudget_meeting)
      get :update, params: {id: meeting.id, parbudget_meeting: meeting.attributes}
      expect(response.status).to be(302)
    end
  end

  describe "DELETE destroy" do
    it "delete element" do
      meeting = create(:parbudget_meeting)
      delete :destroy, params: {id: meeting.id}
      expect(response.status).to be(302)
    end
  end
  
end
