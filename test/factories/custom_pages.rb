FactoryBot.define do
  factory :custom_page do
    title "MyString"
    parent_slug ""
    slug "MyString"
    font_color "#222222"
    published false
    meta_title "Metatitle"
    meta_description "Metadescription"
    meta_keywords "Metakeywords"
  end
end
