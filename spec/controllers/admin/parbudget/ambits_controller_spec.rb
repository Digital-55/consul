require "rails_helper"

describe Admin::Parbudget::AmbitsController do
  before do
    @admin = create(:administrator)
    sign_in(@admin.user)
  end

  describe "GET index" do
    it "seach data" do
      create(:parbudget_ambit)
      get :index
      expect(response.status).to be(200)
    end

    it "seach data order asc" do
      create(:parbudget_ambit)
      get :index, params: {direction: "asc",sort_by: "name"}
      expect(response.status).to be(200)
    end

    it "seach data order desc" do
      create(:parbudget_ambit)
      get :index, params: {direction: "asc",sort_by: "name"}
      expect(response.status).to be(200)
    end

    it "export CSV" do
      create(:parbudget_ambit)
      get :index, params: {format: :csv}
      expect(response.status).to be(200)
    end

    it "search_code" do
      create(:parbudget_ambit)
      get :index,  params: {search_code: 'order'}
      expect(response.status).to be(200)
    end

    it "search_ambit" do
      create(:parbudget_ambit)
      get :index,  params: {search_ambit: 'order'}
      expect(response.status).to be(200)
    end
  end


  describe "POST create_ambit" do
    it "generate element" do
      post :create_ambit
      expect(response.status).to be(302)
    end
  end

  describe "GET update_ambit" do
    it "update element" do
      ambit = create(:parbudget_ambit)
      get :update_ambit, params: {id: ambit.id}
      expect(response.status).to be(302)
    end
  end

  describe "DELETE destroy" do
    it "delete element" do
      ambit = create(:parbudget_ambit)
      delete :destroy, params: {id: ambit.id}
      expect(response.status).to be(302)
    end
  end
  
end
