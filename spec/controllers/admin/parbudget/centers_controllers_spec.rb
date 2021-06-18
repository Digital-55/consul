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

    it "search_code" do
      create(:parbudget_center)
      get :index,  params: {search_code: 'order'}
      expect(response.status).to be(200)
    end

    it "search_ambit" do
      create(:parbudget_center)
      get :index,  params: {search_ambit: 'order'}
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
