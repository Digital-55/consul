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

    it "export CSV" do
      create(:parbudget_project)
      get :index, params: {format: :csv}
      expect(response.status).to be(200)
    end

    it "search_identificator" do
      create(:parbudget_project)
      get :index,  params: {search_identificator: 'order'}
      expect(response.status).to be(200)
    end

    it "search_title" do
      create(:parbudget_project)
      get :index,  params: {search_title: 'order'}
      expect(response.status).to be(200)
    end

    it "search_memory" do
      create(:parbudget_project)
      get :index,  params: {search_memory: 'order'}
      expect(response.status).to be(200)
    end

    it "search_status" do
      create(:parbudget_project)
      get :index,  params: {search_status: 'order'}
      expect(response.status).to be(200)
    end

    it "search_center" do
      create(:parbudget_project)
      get :index,  params: {search_center: 'order'}
      expect(response.status).to be(200)
    end

    it "subnav" do
      create(:parbudget_project)
      get :index,  params: {subnav: 2015}
      expect(response.status).to be(200)
    end

    it "search_year_to" do
      create(:parbudget_project)
      get :index,  params: {search_year_to: 2015}
      expect(response.status).to be(200)
    end

    it "search_year_end" do
      create(:parbudget_project)
      get :index,  params: {search_year_end: 2015}
      expect(response.status).to be(200)
    end

    it "search_year_to and search_year_end" do
      create(:parbudget_project)
      get :index,  params: {search_year_to: 2015, search_year_end: 2015}
      expect(response.status).to be(200)
    end
  end

  describe "GET show_project" do
    it "show element" do
      project = create(:parbudget_project)
      get :show, params: {id: project.id}
      expect(response.status).to be(200)
    end

    it "export pdf" do
      project = create(:parbudget_project)
      get :show, params: {id: project.id, format: :pdf}
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
