class ListModule < CustomPageModule
  belongs_to :custom_page
  has_attached_file :list_icon_one,
                    url: "/system/list_icons/:id/:style_:basename.:extension",
                    path: ":rails_root/public/system/list_icons/:id/:style_:basename.:extension",
                    styles: { icon: "60x60" }
  has_attached_file :list_icon_two,
                    url: "/system/list_icons/:id/:style_:basename.:extension",
                    path: ":rails_root/public/system/list_icons/:id/:style_:basename.:extension",
                    styles: { icon: "60x60" }
  has_attached_file :list_icon_three,
                    url: "/system/list_icons/:id/:style_:basename.:extension",
                    path: ":rails_root/public/system/list_icons/:id/:style_:basename.:extension",
                    styles: { icon: "60x60" }

  # validates :list_title_one, presence: true
  # validates :list_title_two, presence: true
  # validates :list_title_three, presence: true
  # validates_attachment_presence :list_icon_one
  # validates_attachment_presence :list_icon_two
  # validates_attachment_presence :list_icon_three
  validates_attachment_size :list_icon_one, less_than: 1.megabytes
  validates_attachment_size :list_icon_two, less_than: 1.megabytes
  validates_attachment_size :list_icon_three, less_than: 1.megabytes
  validates_attachment_content_type :list_icon_one, content_type: /\Aimage/
  validates_attachment_content_type :list_icon_two, content_type: /\Aimage/
  validates_attachment_content_type :list_icon_three, content_type: /\Aimage/
end