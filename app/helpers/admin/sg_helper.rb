module Admin::SgHelper
    require 'json' 


    def get_filter_sg_tab
        [
            {name: I18n.t('admin.sg.tab.search'), type: 'search'},
            {name: I18n.t('admin.sg.tab.order'), type: 'order'}
        ]
    end

    def get_header_tables_fields
        [
            I18n.t('admin.sg.list.table_name'),
            I18n.t('admin.sg.list.field_name')
        ]
    end

    def get_header_select
        [
            I18n.t('admin.sg.list.key'),
            I18n.t('admin.sg.list.value')
        ]
    end

    def get_tables
        exclusiones = ["DirectUpload", "ImportUser", "I18nContent", "I18nContentTranslation", "ApplicationRecord", "Officing::Residence"]
        tables = []
        Dir.glob(Rails.root.join('app/models/**/*.rb')).each do |x|
            begin
                model =  x.gsub('.rb','').gsub(Rails.root.join('app/models/').to_s, '').gsub('custom/','').singularize.classify
                if exclusiones.exclude?(model.to_s) && !model["Concern"] && !model["Abilities"] && !model["Verification::"] && !model["Sures::"] && !model["Ahoy::"] && !model["Sg::"] && !model["Ckeditor"]
                    tables << ["#{model.constantize.model_name.human} (#{model})", model.constantize.model_name]
                end
            rescue
            end
        end
        
        final = [[I18n.t('admin.sg.form.table_name')+"...", '']]
        final + tables.uniq.sort
    rescue
        [[I18n.t('admin.sg.form.table_name')+"...", '']]
    end

    def get_fields_by_table(table_name)
        model = table_name.singularize.classify.constantize
        fields = []
        if !model.try(:column_names).blank?
            model.try(:column_names).each do |field|
                fields << ["#{model.human_attribute_name(field)} (#{field})",field]
            end
        end

        final = [[I18n.t('admin.sg.form.field_name')+"...", '']]
        final + fields.sort
    rescue
        [[I18n.t('admin.sg.form.field_name')+"...", '']]
    end

    def get_sg_search_types_data
        [
            [I18n.t('admin.sures.searchs_settings.types_data.select'), 'select'],
            [I18n.t('admin.sures.searchs_settings.types_data.checkbox'), 'checkbox'],
            [I18n.t('admin.sures.searchs_settings.types_data.text'), 'text']
        ]
    end

    def get_sg_search_rules
        [
            [I18n.t('admin.sures.searchs_settings.rules.asc'), 'asc'],
            [I18n.t('admin.sures.searchs_settings.rules.desc'), 'desc']
        ]
    end

    def get_sg_select(table_name, field_name)
        case table_name.to_s
        when "Budget"
            case field_name.to_s
            when "phase"
                return Budget::Phase::PHASE_KINDS
            when "currency_symbol"
                Budget::CURRENCY_SYMBOLS
            end
        when "Budget::Investment"
            case field_name.to_s
            when "feasibility"
                return ["feasible", "unfeasible"]
            end
        when "Sures::Actuation"
            case field_name.to_s
            when "status"
                return ["study", "tramit", "process", "fhinish"]
            when "financig_performance"
                return ["planed", "tramit", "ifs", "other"]
            end
        when "AdminNotification"
            case field_name.to_s
            when "segment_recipient"
                return UserSegments.segments.collect
            end
        when "Newsletter"
            case field_name.to_s
            when "segment_recipient"
                return UserSegments.segments.collect
            end
        when "Proposal"
            case field_name.to_s
            when "proposal_type"
                return Legislation::Proposal::VALID_TYPES
            when "retired_reason"
                return Proposal::RETIRE_OPTIONS
            end
        when "Legislation::Proposal"
            case field_name.to_s
            when "proposal_type"
                return Legislation::Proposal::VALID_TYPES
            when "retired_reason"
                return Proposal::RETIRE_OPTIONS
            end
        end
        []
    rescue
        []
    end

end