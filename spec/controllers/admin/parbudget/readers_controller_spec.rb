require "rails_helper"

describe Admin::Parbudget::ReadersController do
  before do
    @admin = create(:administrator)
    sign_in(@admin.user)
  end

  describe "GET index" do
    it "get index" do
      get :index
      expect(response.status).to be(200)
    end
  end

  describe "DELETE destroy" do
    it "delete editor" do
      user = create(:user)
      reader = Parbudget::Reader.create(user_id: user.id)
      delete :destroy, params: {id: reader.id}
      expect(response.status).to be(302)
    end
  end
  
end