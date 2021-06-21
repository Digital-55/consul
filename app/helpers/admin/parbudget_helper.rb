module Admin::ParbudgetHelper

    def link_to_parbudget_sorted_by(column, translation)
        direction = set_parbudget_direction(params[:direction])
        icon = set_parbudget_sorting_icon(direction, column)

        link_to(
            "#{translation} <span class='icon-sortable #{icon}'></span>".html_safe,
            current_path_with_query_params(sort_by: column, direction: direction , params: params.except(:direction,:sort_by))
        )
    end

    def set_parbudget_sorting_icon(direction, sort_by)
        if sort_by.to_s == params[:sort_by]
            if direction == "desc"
                "desc"
            else
                "asc"
            end
        else
            ""
        end
    end

    def set_parbudget_direction(current_direction)
        current_direction == "desc" ? "asc" : "desc"
    end
end