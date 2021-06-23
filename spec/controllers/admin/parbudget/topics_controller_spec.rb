require "rails_helper"

describe Admin::Parbudget::TopicsController do
  before do
    @admin = create(:administrator)
    sign_in(@admin.user)
  end

  describe "GET index" do
    it "seach data" do
      create(:parbudget_topic)
      get :index
      expect(response.status).to be(200)
    end

    it "seach data order asc" do
      create(:parbudget_topic)
      get :index, params: {direction: "asc",sort_by: "name"}
      expect(response.status).to be(200)
    end

    it "seach data order desc" do
      create(:parbudget_topic)
      get :index, params: {direction: "asc",sort_by: "name"}
      expect(response.status).to be(200)
    end

    it "export CSV" do
      create(:parbudget_topic)
      get :index, params: {format: :csv}
      expect(response.status).to be(200)
    end

    it "search_topic" do
      create(:parbudget_topic)
      get :index,  params: {search_topic: 'order'}
      expect(response.status).to be(200)
    end
  end


  describe "POST generate_topic" do
    it "generate element" do
      post :generate_topic
      expect(response.status).to be(302)
    end
  end

  describe "GET update_topic" do
    it "update element" do
      topic = create(:parbudget_topic)
      get :update_topic, params: {id: topic.id}
      expect(response.status).to be(302)
    end
  end

  describe "DELETE destroy" do
    it "delete element" do
      topic = create(:parbudget_topic)
      delete :destroy, params: {id: topic.id}
      expect(response.status).to be(302)
    end
  end
  
end
