class Admin::MenusController < Admin::BaseController
  include Translatable

  has_filters %w{all header footer}, only: :index

  def index
    @menus =  Menu.send(@current_filter).page(params[:page])
  end

end