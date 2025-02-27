module MapLocationsHelper

  def map_location_available?(map_location)
    map_location.present? && map_location.available?
  end

  def map_location_latitude(map_location)
    map_location.present? && map_location.latitude.present? ? map_location.latitude : Setting["map.latitude"]
  end

  def map_location_longitude(map_location)
    map_location.present? && map_location.longitude.present? ? map_location.longitude : Setting["map.longitude"]
  end

  def map_location_zoom(map_location)
    map_location.present? && map_location.zoom.present? ? map_location.zoom : Setting["map.zoom"]
  end

  def map_location_input_id(prefix, attribute)
    "#{prefix}_map_location_attributes_#{attribute}"
  end

  def map_location_remove_marker_link_id(map_location)
    "remove-marker-link-#{dom_id(map_location)}"
  end

  def render_map(map_location, parent_class, editable, remove_marker_label, investments_coordinates=nil)
    map_location = MapLocation.new if map_location.nil?
    map = content_tag :div, "",
                      id: dom_id(map_location),
                      class: "map_location map",
                      data: prepare_map_settings(map_location, editable, parent_class, investments_coordinates)
    map += map_location_remove_marker(map_location, remove_marker_label) if editable
    map
  end

  def map_location_remove_marker(map_location, text)
    content_tag :div, class: "margin-bottom" do
      content_tag :a,
                  id: map_location_remove_marker_link_id(map_location),
                  href: "#",
                  class: "js-location-map-remove-marker location-map-remove-marker" do
        text
      end
    end
  end

  private

  def prepare_map_settings(map_location, editable, parent_class, investments_coordinates=nil)
    options = {
      map: "",
      map_center_latitude: map_location_latitude(map_location),
      map_center_longitude: map_location_longitude(map_location),
      map_zoom: map_location_zoom(map_location),
      map_tiles_provider: Rails.application.secrets.map_tiles_provider,
      map_tiles_provider_attribution: Rails.application.secrets.map_tiles_provider_attribution,
      marker_editable: editable,
      marker_remove_selector: "##{map_location_remove_marker_link_id(map_location)}",
      latitude_input_selector: "##{map_location_input_id(parent_class, "latitude")}",
      longitude_input_selector: "##{map_location_input_id(parent_class, "longitude")}",
      zoom_input_selector: "##{map_location_input_id(parent_class, "zoom")}",
      marker_investments_coordinates: investments_coordinates
    }
    options[:marker_latitude] = map_location.latitude if map_location.latitude.present?
    options[:marker_longitude] = map_location.longitude if map_location.longitude.present?

    if render_related_proposals?(map_location, editable)
      related_proposals_coordinates = map_related_proposals_coordinates(map_location.proposal)

      if related_proposals_coordinates.present?
        options[:marker_related_proposals_coordinates] = related_proposals_coordinates
        options[:related_proposals_layer_text] = t("map.related_proposals")
      end
    end
    options
  end

  def map_related_proposals_coordinates(proposal)
    related_proposals = proposal.related_proposals.published.not_retired.not_archived.joins(:map_location).order(:created_at)

    related_proposals.map do |related_proposal|
      related_proposal.map_location.json_data.merge({ url: proposal_path(related_proposal), title: related_proposal.title })
    end
  end

  def render_related_proposals?(map_location, editable)
     map_location.proposal.present? && !editable
  end
end
