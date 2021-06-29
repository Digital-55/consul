module Admin::ComplanHelper

    def link_to_complan_sorted_by(column, translation)
        direction = set_complan_direction(params[:direction])
        icon = set_complan_sorting_icon(direction, column)

        link_to(
            "#{translation} <span class='icon-sortable #{icon}'></span>".html_safe,
            current_path_with_query_params(sort_by: column, direction: direction , params: params.except(:direction,:sort_by))
        )
    end

    def set_complan_sorting_icon(direction, sort_by)
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

    def set_complan_direction(current_direction)
        current_direction == "desc" ? "asc" : "desc"
    end
end