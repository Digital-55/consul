class ClaimModule < CustomPageModule
  belongs_to :custom_page
  TEXT_MAX_LENGTH = 5000
  validates :claim, presence: true
end