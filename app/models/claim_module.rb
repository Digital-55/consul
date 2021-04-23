class ClaimModule < CustomPageModule
  belongs_to :custom_page
  validates :claim, presence: true
end