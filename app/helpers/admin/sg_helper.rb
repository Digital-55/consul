module Admin::SgHelper
    require 'json' 


    def get_filter_sg_tab
        [
            {name: I18n.t('admin.sures.searchs_settings.filter.search'), type: 'search'},
            {name: I18n.t('admin.sures.searchs_settings.filter.order'), type: 'order'}
        ]
    end

    def get_header_tables_fields
        [
            I18n.t('admin.sures.searchs_settings.filter.search'),
            I18n.t('admin.sures.searchs_settings.filter.search')
        ]
    end

end