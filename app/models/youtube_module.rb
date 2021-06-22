class YoutubeModule < CustomPageModule
  belongs_to :custom_page
  validates :youtube_url,
            presence: true,
            format: { with:
                      /(?:https?:\/\/)?(?:www\.)?(?:youtu\.be\/|youtube\.com\/(?:embed\/|v\/|watch\?v=|watch\?.+&v=))((\w|-){11})(?:\S+)?$ ||
                      https?:\/\/(www.)?vimeo.com\/([0-9]{9}) ||
                      https:\/\/([a-z0-9]+[.])*slideshare.net\/[a-zA-Z0-9\-]+\/[a-zA-Z0-9\-]+ ||
                      https:\/\/([a-z0-9]+[.])*prezi.com\/[a-zA-Z0-9\-]+\/[a-zA-Z0-9-\/]+/
                    }
end