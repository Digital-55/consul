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
end
    describe "agend_admin" do
    end
        end
          expect(response.status).to eq(200)
          
    
        it "init page agend admin" do
          get :encuentrosconexpertos
    describe "encuentrosconexpertos" do

    end
        end
          expect(response.status).to eq(200)
          
          get :eventos
        it "init page agend admin" do
    describe "eventos" do
    end
    

        end
          expect(response.status).to eq(200)
          
          get :agend_admin
    
        it "init page agend admin" do