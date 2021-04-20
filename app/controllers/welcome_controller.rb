class WelcomeController < ApplicationController
  skip_authorization_check
  before_action :set_user_recommendations, only: :index, if: :current_user
  before_action :authenticate_user!, only: :welcome

  layout "devise", only: [:welcome, :verification]

  def index
    @header = Widget::Card.header.first
    @feeds = Widget::Feed.active
    @cards = Widget::Card.body
    @banners = Banner.in_section("homepage").with_active
  end

  def welcome
    if current_user.level_three_verified?
      redirect_to page_path("welcome_level_three_verified")
    elsif current_user.level_two_or_three_verified?
      redirect_to page_path("welcome_level_two_verified")
    else
      redirect_to page_path("welcome_not_verified")
    end
  end

  def verification
    redirect_to verification_path if signed_in?
  end

  def encuentrosconexpertos
    @key = Rails.application.secrets.yt_api_key
    @key_x = Rails.application.secrets.yt_api_key_x
    @embed_domain = Rails.application.secrets.embed_domain
    @videoId = Setting.find_by(key: "youtube_connect").value
    @playlistId = Setting.find_by(key: "youtube_playlist_connect").value


  end

  def eventos
    @key = Rails.application.secrets.yt_api_key
    @key_x = Rails.application.secrets.yt_api_key_x
    @embed_domain = Rails.application.secrets.embed_domain
    @videoId = Setting.find_by(key: "eventos_youtube_connect").value
    @playlistId = Setting.find_by(key: "eventos_youtube_playlist_connect").value


  end

  def generic_search
    @orders_generic = Sg::Setting.order_settings.active.order(id: :asc)
    get_parametrizer(params)
    

    # if aux_active
    #   #@actuations = Sures::Actuation.joins(:translations).all
    #   @resultado =  @resultado + (@resultado.blank? ? parametrize[:search] : "/#{parametrize[:search]}")
    #   if !parametrize[:search].blank?
    #       @actuations = @actuations.where("translate(UPPER(cast(proposal_title as varchar)), 'ÁÉÍÓÚ', 'AEIOU') LIKE translate(UPPER(cast(? as varchar)), 'ÁÉÍÓÚ', 'AEIOU') OR
    #           translate(UPPER(cast(proposal_objective as varchar)), 'ÁÉÍÓÚ', 'AEIOU') LIKE translate(UPPER(cast(? as varchar)), 'ÁÉÍÓÚ', 'AEIOU') OR
    #           translate(UPPER(cast(territorial_scope as varchar)), 'ÁÉÍÓÚ', 'AEIOU') LIKE translate(UPPER(cast(? as varchar)), 'ÁÉÍÓÚ', 'AEIOU') OR
    #           translate(UPPER(cast(location_performance as varchar)), 'ÁÉÍÓÚ', 'AEIOU') LIKE translate(UPPER(cast(? as varchar)), 'ÁÉÍÓÚ', 'AEIOU') OR
    #           translate(UPPER(cast(technical_visibility as varchar)), 'ÁÉÍÓÚ', 'AEIOU') LIKE translate(UPPER(cast(? as varchar)), 'ÁÉÍÓÚ', 'AEIOU') OR
    #           translate(UPPER(cast(actions_taken as varchar)), 'ÁÉÍÓÚ', 'AEIOU') LIKE translate(UPPER(cast(? as varchar)), 'ÁÉÍÓÚ', 'AEIOU') OR
    #           translate(UPPER(cast(other as varchar)), 'ÁÉÍÓÚ', 'AEIOU') LIKE translate(UPPER(cast(? as varchar)), 'ÁÉÍÓÚ', 'AEIOU') OR
    #           translate(UPPER(cast(tracking as varchar)), 'ÁÉÍÓÚ', 'AEIOU') LIKE translate(UPPER(cast(? as varchar)), 'ÁÉÍÓÚ', 'AEIOU')",
    #           "%#{parametrize[:search]}%", "%#{parametrize[:search]}%", "%#{parametrize[:search]}%",
    #           "%#{parametrize[:search]}%", "%#{parametrize[:search]}%", "%#{parametrize[:search]}%",
    #           "%#{parametrize[:search]}%", "%#{parametrize[:search]}%"
    #       )
    #   end

    #   if !parametrize[:show_fields].blank? && parametrize[:show_fields].to_s != "true"
    #       aux_fields.each do |f|
    #           if !parametrize[f.to_sym].blank? && f.to_s != "search"
    #               aux_field_search = @sures_searchs_settings.select {|x| x.title.parameterize.underscore.to_s == f.to_s }[0]
    #               if !aux_field_search.blank?
    #                   parse_data_json(aux_field_search.data).each do |k,v| 
    #                       if v.to_s == parametrize[f.to_sym].to_s
    #                           @resultado =  @resultado + (@resultado.blank? ? k : "/#{k}")
    #                           break
    #                       end
    #                   end
                      
    #                   @actuations = @actuations.where("translate(UPPER(cast(#{aux_field_search.field} as varchar)), 'ÁÉÍÓÚ', 'AEIOU') LIKE translate(UPPER(cast(? as varchar)), 'ÁÉÍÓÚ', 'AEIOU')", "%#{parametrize[f.to_sym]}%")
    #               end
    #           end
    #       end
    #   end

    #   aux_order = "updated_at desc"
    #   if  @sures_orders_filter.blank?
    #       @type = ""
    #   elsif !params[:type].blank?
    #       aux = @sures_orders_filter.select {|order| order.title.parameterize.underscore == params[:type] }.first
    #       aux_order = "#{aux.field} #{aux.rules.split(';').length > 1 ? aux.rules.split(';')[1] : aux.rules }"
    #       @type = params[:type]
    #   else
    #       aux = @sures_orders_filter.select {|order| order.rules.to_s.include?('default') }.first
    #       if aux.blank?
    #           aux = @sures_orders_filter.first
    #       end
    #       aux_order = "#{aux.field} #{aux.rules.split(';').length > 1 ? aux.rules.split(';')[1] : aux.rules }"
    #       @type = aux.title.parameterize.underscore
    #   end
    #   @actuations = @actuations.order(aux_order)
    #   @actuations = @actuations.page(params[:page])
    # end
  end

  private

  def set_user_recommendations
    @recommended_debates = Debate.recommendations(current_user).sort_by_recommendations.limit(3)
    @recommended_proposals = Proposal.recommendations(current_user).sort_by_recommendations.limit(3)
  end

  def get_parametrizer(parametrize)
    aux_active = false
    @resultado = ""

    aux_fields = @generic_searchs_settings.map {|f| f.title.parameterize.underscore.to_s }
    aux_fields.push('search')

    aux_fields.each do |f|
        if !parametrize[f.to_sym].blank?
            aux_active = true
            @resultado =  @resultado + (@resultado.blank? ? parametrize[f.to_sym] : "/#{parametrize[f.to_sym]}")
        end
    end

    @search_terms = aux_active
    # @resultado =  @resultado + (@resultado.blank? ? parametrize[:search] : "/#{parametrize[:search]}")

    # if !parametrize[:show_fields].blank? && parametrize[:show_fields].to_s != "true"
    #   aux_fields.each do |f|
    #     if !parametrize[f.to_sym].blank? && f.to_s != "search"
    #       aux_field_search = @generic_searchs_settings.select {|x| x.title.parameterize.underscore.to_s == f.to_s }[0]
    #       if !aux_field_search.blank?
    #         parse_data_json(aux_field_search.data).each do |k,v| 
    #           if v.to_s == parametrize[f.to_sym].to_s
    #             @resultado =  @resultado + (@resultado.blank? ? k : "/#{k}")
    #             break
    #           end
    #         end
    #       end
    #     end
    #   end
    # end
  end

end
