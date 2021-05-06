class CustomImageModule < CustomPageModule
  belongs_to :custom_page
  has_attached_file :custom_image,
                    url: "/system/custom_images/:id/:style_:basename.:extension",
                    path: ":rails_root/public/system/custom_images/:id/:style_:basename.:extension",
                    styles: { content: "800>", thumb: "118x100#" }

  validates_attachment_presence :custom_image
  validates_attachment_size :custom_image, less_than: 2.megabytes
  validates_attachment_content_type :custom_image, content_type: /\Aimage/
end