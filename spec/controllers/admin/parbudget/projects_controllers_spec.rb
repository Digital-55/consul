require "rails_helper"

describe Admin::Parbudget::ProjectsController do
  before do
    @admin = create(:administrator)
    sign_in(@admin.user)
  end

  describe "GET index" do
    it "seach data" do
      create(:parbudget_project)
      get :index
      expect(response.status).to be(200)
    end

    it "search_code" do
      create(:parbudget_project)
      get :index,  params: {search_code: 'order'}
      expect(response.status).to be(200)
    end

    it "search_ambit" do
      create(:parbudget_project)
      get :index,  params: {search_ambit: 'order'}
      expect(response.status).to be(200)
    end
  end

  describe "GET new_project" do
    it "new element" do
      get :new
      expect(response.status).to be(200)
    end
  end

  describe "GET edit_project" do
    it "edit element" do
      project = create(:parbudget_project)
      get :edit, params: {id: project.id}
      expect(response.status).to be(200)
    end
  end

  describe "POST create_project" do
    it "generate element" do
      project = build(:parbudget_project)
      post :create, params: {parbudget_project: project.attributes}
      expect(response.status).to be(302)
    end
  end

  describe "PUT update_project" do
    it "update element" do
      project = create(:parbudget_project)
      get :update, params: {id: project.id, parbudget_project: project.attributes}
      expect(response.status).to be(302)
    end
  end

  describe "DELETE destroy" do
    it "delete element" do
      project = create(:parbudget_project)
      delete :destroy, params: {id: project.id}
      expect(response.status).to be(302)
    end
  end
  
end
