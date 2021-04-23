class YoutubeModule < CustomPageModule
  belongs_to :custom_page
  validates :youtube_url, presence: true, format: { with: /(?:http:\/\/)?(?:www\.)?youtube\.com\/watch\?v=([a-zA-Z0-9_-]*)/ }
end