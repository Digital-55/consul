class YoutubeModule < CustomPageModule
  belongs_to :custom_page
  TEXT_MAX_LENGTH = 20000
  validates :youtube_url,
            presence: true,
            format: { with:
                      /http(?:s?):\/\/(?:www\.)?youtu(?:be\.com\/watch\?v=|\.be\/)([\w\-\_]*)(&(amp;)?‌​[\w\?‌​=]*)? ||
                      https?:\/\/(www.)?vimeo.com\/([0-9]{9}) ||
                      https:\/\/([a-z0-9]+[.])*slideshare.net\/[a-zA-Z0-9\-]+\/[a-zA-Z0-9\-]+ ||
                      https:\/\/([a-z0-9]+[.])*prezi.com\/[a-zA-Z0-9\-]+\/[a-zA-Z0-9-\/]+/
                    }
end