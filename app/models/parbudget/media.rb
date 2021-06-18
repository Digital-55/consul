class Parbudget::Media < ApplicationRecord
  include DocumentsHelper
  include DocumentablesHelper
  include ImagesHelper
  include ImageablesHelper

  belongs_to :parbudget_project, class_name: "Parbudget::Project", foreign_key: "parbudget_project_id"
  has_attached_file :attachment,
    styles: lambda{ |a|
      return {} unless a.content_type.in? %w(image/jpeg image/png image/jpg image/gif)
      { large: "x#{Setting["uploads.images.min_height"]}", medium: "300x300#", thumb: "140x245#" }
    },
    url: "/system/:class/:prefix/:style/:hash.:extension",
    hash_data: ":class/:style",
    use_timestamp: false,
    processors: lambda { |a| 
        begin
            a.is_video? ? [ :ffmpeg ] : [ :thumbnail ] 
        rescue => exception
            [ :thumbnail ] 
        end
    },
    hash_secret: Rails.application.secrets.secret_key_base

  validates :title, :attachment, presence: true
  do_not_validate_attachment_file_type :attachment

  attr_accessor :original_filename

  self.table_name = "parbudget_medias"

  validate :validate_attachment_content_type,         if: -> { attachment.present? }
  # validate :validate_attachment_size,                 if: -> { attachment.present? }
  # validate :validate_image_dimensions, if: -> { attachment.present? && attachment.dirty? && attachment.content_type != 'video/mp4' } 

  Paperclip.interpolates :prefix do |attachment, style|
    attachment.instance.prefix(attachment, style)
  end

  def prefix(attachment, _style)
    if !attachment.instance.persisted?
      "cached_attachments/project/#{attachment.instance.project_id}"
    else
      ":attachment/:id_partition"
    end
  end

  def humanized_content_type
    attachment_content_type.split("/").last.upcase
  end

  private

    def validate_attachment_size
      if attachment_file_size > documentable_class.max_file_size
        errors.add(:attachment, I18n.t("documents.errors.messages.in_between",
                                      min: "0 Bytes",
                                      max: "#{max_file_size(documentable_class)} MB"))
      end
    end

    def validate_attachment_content_type
      if self.image? 

      elsif self.document?

      end
      # if !accepted_content_types(documentable_class).include?(attachment_content_type)
      #   accepted_content_types = documentable_humanized_accepted_content_types(documentable_class)
      #   message = I18n.t("documents.errors.messages.wrong_content_type",
      #                    content_type: attachment_content_type,
      #                    accepted_content_types: accepted_content_types)
      #   errors.add(:attachment, message)
      # end
    end

    
  
      def validate_image_dimensions
        if attachment_of_valid_content_type?
          return true if imageable_class == Widget::Card
  
          dimensions = Paperclip::Geometry.from_file(attachment.queued_for_write[:original].path)
          min_width = Setting["uploads.images.min_width"].to_i
          min_height = Setting["uploads.images.min_height"].to_i
          errors.add(:attachment, :min_image_width, required_min_width: min_width) if dimensions.width < min_width
          errors.add(:attachment, :min_image_height, required_min_height: min_height) if dimensions.height < min_height
        end
      end
  
      def validate_attachment_size
        if imageable_class &&
           attachment_file_size > Setting["uploads.images.max_size"].to_i.megabytes
          errors.add(:attachment, I18n.t("images.errors.messages.in_between",
                                       min: "0 Bytes",
                                       max: "#{imageable_max_file_size} MB"))
        end
      end
  
      
  
      def validate_attachment_content_type
        if imageable_class && !attachment_of_valid_content_type?
          message = I18n.t("images.errors.messages.wrong_content_type",
                           content_type: attachment_content_type,
                           accepted_content_types: imageable_humanized_accepted_content_types)
          errors.add(:attachment, message)
        end
      end
end

