require "rails_helper"

describe Admin::Parbudget::CentersController do
  before do
    @admin = create(:administrator)
    sign_in(@admin.user)
  end

  describe "GET index" do
    it "seach data" do
      create(:parbudget_center)
      get :index
      expect(response.status).to be(200)
    end

    it "seach data order asc" do
      create(:parbudget_center)
      get :index, params: {direction: "asc",sort_by: "code"}
      expect(response.status).to be(200)
    end

    it "seach data order desc" do
      create(:parbudget_center)
      get :index, params: {direction: "asc",sort_by: "code"}
      expect(response.status).to be(200)
    end

    it "export CSV" do
      create(:parbudget_center)
      get :index, params: {format: :csv}
      expect(response.status).to be(200)
    end

    it "search_center_code" do
      create(:parbudget_center)
      get :index,  params: {search_center_code: 'order'}
      expect(response.status).to be(200)
    end

    it "search_section_code" do
      create(:parbudget_center)
      get :index,  params: {search_section_code: 'order'}
      expect(response.status).to be(200)
    end

    it "search_program_code" do
      create(:parbudget_center)
      get :index,  params: {search_program_code: 'order'}
      expect(response.status).to be(200)
    end

    it "search_denomination" do
      create(:parbudget_center)
      get :index,  params: {search_denomination: 'order'}
      expect(response.status).to be(200)
    end

    it "search_responsible" do
      create(:parbudget_center)
      get :index,  params: {search_responsible: 'order'}
      expect(response.status).to be(200)
    end

    it "search_project" do
      create(:parbudget_center)
      get :index,  params: {search_project: 1}
      expect(response.status).to be(200)
    end
  end

  describe "GET show_center" do
    it "show element" do
      center = create(:parbudget_center)
      get :show, params: {id: center.id}
      expect(response.status).to be(200)
    end

    it "export pdf" do
      center = create(:parbudget_center)
      get :show, params: {id: center.id, format: :pdf}
      expect(response.status).to be(200)
    end
  end

  describe "GET new_center" do
    it "new element" do
      get :new
      expect(response.status).to be(200)
    end
  end

  describe "GET edit_center" do
    it "edit element" do
      center = create(:parbudget_center)
      get :edit, params: {id: center.id}
      expect(response.status).to be(200)
    end
  end

  describe "POST create_center" do
    it "generate element" do
      center = build(:parbudget_center)
      post :create, params: {parbudget_center: center.attributes}
      expect(response.status).to be(302)
    end
  end

  describe "PUT update_center" do
    it "update element" do
      center = create(:parbudget_center)
      get :update, params: {id: center.id ,parbudget_center: center.attributes}
      expect(response.status).to be(302)
    end
  end

  describe "DELETE destroy" do
    it "delete element" do
      center = create(:parbudget_center)
      delete :destroy, params: {id: center.id}
      expect(response.status).to be(302)
    end
  end
  
end
