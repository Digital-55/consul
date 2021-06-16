class YoutubeModule < CustomPageModule
  belongs_to :custom_page
  validates :youtube_url, presence: true, format: { with: /http(?:s?):\/\/(?:www\.)?youtu(?:be\.com\/watch\?v=|\.be\/)([\w\-\_]*)(&(amp;)?‌​[\w\?‌​=]*)?/ }
end