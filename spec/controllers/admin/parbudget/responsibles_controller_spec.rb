require "rails_helper"

describe Admin::Parbudget::ResponsiblesController do
  before do
    @admin = create(:administrator)
    sign_in(@admin.user)
  end

  describe "GET index" do
    it "seach data" do
      create(:parbudget_responsible)
      get :index
      expect(response.status).to be(200)
    end

    it "export CSV" do
      create(:parbudget_responsible)
      get :index, params: {format: :csv}
      expect(response.status).to be(200)
    end

    it "search_responsible" do
      create(:parbudget_responsible)
      get :index,  params: {search_responsible: 'order'}
      expect(response.status).to be(200)
    end

    it "search_phone" do
      create(:parbudget_responsible)
      get :index,  params: {search_phone: 'order'}
      expect(response.status).to be(200)
    end

    it "search_email" do
      create(:parbudget_responsible)
      get :index,  params: {search_email: 'order'}
      expect(response.status).to be(200)
    end

    it "search_position" do
      create(:parbudget_responsible)
      get :index,  params: {search_position: 'order'}
      expect(response.status).to be(200)
    end

    it "search_center" do
      create(:parbudget_responsible)
      get :index,  params: {search_center: 'order'}
      expect(response.status).to be(200)
    end

    it "subnav" do
      create(:parbudget_responsible)
      get :index,  params: {subnav: 1}
      expect(response.status).to be(200)
    end
  end

  describe "GET show_responsible" do
    it "show element" do
      responsible = create(:parbudget_responsible)
      get :show, params: {id: responsible.id}
      expect(response.status).to be(200)
    end

    it "export pdf" do
      responsible = create(:parbudget_responsible)
      get :show, params: {id: responsible.id, format: :pdf}
      expect(response.status).to be(200)
    end
  end

  describe "GET new_responsible" do
    it "new element" do
      get :new
      expect(response.status).to be(200)
    end
  end

  describe "GET edit_responsible" do
    it "edit element" do
      responsible = create(:parbudget_responsible)
      get :edit, params: {id: responsible.id}
      expect(response.status).to be(200)
    end
  end

  describe "POST create_responsible" do
    it "generate element" do
      responsible = build(:parbudget_responsible)
      post :create, params: {parbudget_responsible: responsible.attributes}
      expect(response.status).to be(302)
    end
  end

  describe "PUT update_responsible" do
    it "update element" do
      responsible = create(:parbudget_responsible)
      get :update, params: {id: responsible.id, parbudget_responsible: responsible.attributes}
      expect(response.status).to be(302)
    end
  end

  describe "DELETE destroy" do
    it "delete element" do
      responsible = create(:parbudget_responsible)
      delete :destroy, params: {id: responsible.id}
      expect(response.status).to be(302)
    end
  end
  
end
