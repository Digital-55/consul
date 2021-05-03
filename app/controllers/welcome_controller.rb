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
    @search_settings = Sg::Setting.search_settings.active.order(id: :asc)
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
    @resultado = []

    aux_fields = @generic_searchs_settings.map {|f| f.title.parameterize.underscore.to_s }
    aux_fields.push('search')

    aux_fields.each do |f|
        if !parametrize[f.to_sym].blank?
          aux_active = true
          search_aux = f.to_s=="search" ? Sg::Generic.search_type.first : @search_settings.select {|x| x.title.parameterize.underscore.to_s == f.to_s }[0]
          sg_selects = search_aux.try(:sg_selects)
          sg_tables = search_aux.try(:sg_table_fields)
          tables_aux = ""
          tables_array = []

          if !sg_tables.blank?
            sg_tables.each {|t| tables_array.push(t.table_name)}

            tables_array.uniq.each {|a| tables_aux = tables_aux + (tables_aux.blank? ? a.singularize.classify.constantize.model_name.human : " / #{a.singularize.classify.constantize.model_name.human}")}                      
          end

         

        
          search_data_aux = parametrize[f.to_sym]
          if !search_aux.try(:data_type).blank? 
            case search_aux.try(:data_type).to_s
            when "select"
              search_data_aux = sg_selects.select {|x| x.value.to_s == parametrize[f.to_sym].to_s }[0].try(:key)
            when "checkbox"
              search_data_aux = parametrize[f.to_sym].to_s == "true" ? "Sí" : "No"
            end
          end 
          
          @resultado.push({tabla: tables_aux, search: search_data_aux, field: (f.to_s=="search" ? "Barra de búsqueda general" : search_aux.try(:title)), count: 0, id: f.to_sym})           
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
