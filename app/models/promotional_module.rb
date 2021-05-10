class PromotionalModule < CustomPageModule
  belongs_to :custom_page
  has_attached_file :promo_image_one,
                    url: "/system/promo_images/:id/:style_:basename.:extension",
                    path: ":rails_root/public/system/promo_images/:id/:style_:basename.:extension",
                    styles: { content: "800>", thumb: "118x100#" }
  has_attached_file :promo_image_two,
                    url: "/system/promo_images/:id/:style_:basename.:extension",
                    path: ":rails_root/public/system/promo_images/:id/:style_:basename.:extension",
                    styles: { content: "800>", thumb: "118x100#" }
  has_attached_file :promo_image_three,
                    url: "/system/promo_images/:id/:style_:basename.:extension",
                    path: ":rails_root/public/system/promo_images/:id/:style_:basename.:extension",
                    styles: { content: "800>", thumb: "118x100#" }

  # validates_attachment_presence :promo_image_one
  # validates_attachment_presence :promo_image_two
  # validates_attachment_presence :promo_image_three
  validates_attachment_size :promo_image_one, less_than: 2.megabytes
  validates_attachment_size :promo_image_two, less_than: 2.megabytes
  validates_attachment_size :promo_image_three, less_than: 2.megabytes
  validates_attachment_content_type :promo_image_one, content_type: /\Aimage/
  validates_attachment_content_type :promo_image_two, content_type: /\Aimage/
  validates_attachment_content_type :promo_image_three, content_type: /\Aimage/
end