require "rails_helper"

describe Admin::SgsController do
  before do
    @admin = create(:administrator)
    sign_in(@admin.user)
  end

  describe "GET index" do
    it "seach data" do
      create(:sg_generic)
      get :index
      expect(response.status).to be(200)
    end

    it "seach type order" do
      create(:sg_generic)
      get :index,  params: {type: 'order'}
      expect(response.status).to be(200)
    end

    it "seach type search" do
      create(:sg_generic)
      get :index, params: {type: 'search'}
      expect(response.status).to be(200)
    end
  end


  describe "POST create_generic" do
    it "generate element generic" do
      post :create_generic, params: {generic_table_name: "Xxx", generic_field_name: "created_at"}
      expect(response.status).to be(302)
    end
  end

  describe "GET delete_generic" do
    it "delete element generic" do
      sg_generic = create(:sg_generic)
      get :delete_generic, params: {id: sg_generic.id}
      expect(response.status).to be(302)
    end
  end

  describe "POST generate_table_setting" do
    it "create element table setting" do
      sg_generic = create(:sg_setting)
      post :generate_table_setting, params: {id: sg_generic.id, "#{sg_generic.id}_table_name": "Prueba", "#{sg_generic.id}_type": "search", "#{sg_generic.id}_field_name": "id"}
      expect(response.status).to be(302)
    end
  end

  describe "GET delete_table_setting" do
    it "delete element setting" do
      sg_table_setting = create(:sg_table_field)
      get :delete_table_setting, params: {id: sg_table_setting}
      expect(response.status).to be(302)
    end
  end

  describe "POST generate_setting" do
    it "create element setting" do
      post :generate_setting
      expect(response.status).to be(302)
    end
  end

  describe "POST update_setting" do
    it "update element setting" do
      sg_setting = create(:sg_setting)
      post :update_setting, params: {id: sg_setting.id, "#{sg_setting.id}_title": "Prueba X", "#{sg_setting.id}_setting_type": "select", "#{sg_setting.id}_active": true}
      expect(response.status).to be(302)
    end

  end

  describe "GET delete_setting" do
    it "delete element setting" do
      sg_setting = create(:sg_setting)
      get :delete_setting, params: {id: sg_setting.id}
      expect(response.status).to be(302)
    end
  end

  describe "POST generate_table_select" do
    it "crete element table select" do
      sg_setting = create(:sg_setting)
      post :generate_table_select, params: {id: sg_setting.id, "#{sg_setting.id}_key": "Prueba X", "#{sg_setting.id}_value": "select"}
      expect(response.status).to be(302)
    end

  end

  describe "GET delete_table_select" do
    it "delete element table select" do
      sg_table_select = create(:sg_select)
      get :delete_table_select, params: {id: sg_table_select.id}
      expect(response.status).to be(302)
    end
  end
end
