require "rails_helper"

describe WelcomeController do
  before do
    @admin = create(:administrator)
    sign_in(@admin.user)
  end

  describe "GET search public" do
    it "seach data" do
      create(:sg_generic)
      create(:sg_setting)
      create(:sg_table_field)
      create(:sg_select)
      get :generic_search, params: {search: "n"}
      expect(response.status).to be(200)
    end
  end
  describe "agend_admin" do
    it "init page agend admin" do

      get :agend_admin
      expect(response.status).to eq(200)
    end
  end
  describe "eventos" do
    it "init page agend admin" do
      get :eventos
      expect(response.status).to eq(200)

    end

    
  end

  describe "encuentrosconexpertos" do
    it "init page agend admin" do
      get :encuentrosconexpertos
      expect(response.status).to eq(200)
    end
  end

end
         