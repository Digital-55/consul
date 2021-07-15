FactoryBot.define do
  factory :menu_item do
    title "Menu Item"
    item_type "url"
    url "http://example.com"
    page_link ""
    parent_item_id 0
    position 1
    editable false
    menu nil
  end
end
