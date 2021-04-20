class Subtitle < CustomPageModule
  belongs_to :custom_page
  validates :subtitle, presence: true
end