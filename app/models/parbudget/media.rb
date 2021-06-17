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


    do_not_validate_attachment_file_type :attachment

    # validates_attachment_content_type :attachment, content_type: /\Aimage\/.*\z/ , if: 'image?'
    # validates_attachment_content_type :attachment,
    #                 content_type: %w(
    #                   application/x-7z-compressed
    #                   image/bmp
    #                   txt/csv
    #                   application/msword
    #                   application/vnd.openxmlformats-officedocument.wordprocessingml.document
    #                   application/vnd.openxmlformats-officedocument.wordprocessingml.template
    #                   image/gif
    #                   image/jpeg
    #                   application/vnd.oasis.opendocument.graphics
    #                   application/vnd.oasis.opendocument.presentation
    #                   application/vnd.oasis.opendocument.spreadsheet
    #                   application/vnd.oasis.opendocument.text
    #                   application/pdf
    #                   image/png
    #                   application/vnd.ms-powerpoint
    #                   application/vnd.openxmlformats-officedocument.presentationml.presentation
    #                   application/rtf
    #                   application/x-rar-compressed
    #                   text/plain
    #                   image/tiff
    #                   application/x-tar
    #                   application/vnd.ms-excel
    #                   application/vnd.openxmlformats-officedocument.spreadsheetml.sheet
    #                   text/xml
    #                   application/zip
    #                 ),
    #                 if: 'document?'

    # delegate  :image?, :document?, :kind_i18n, to: :link_type, allow_nil: true
   
    attr_accessor :cached_attachment, :remove, :original_filename

    self.table_name = "parbudget_medias"

    # validate :attachment_presence
    # validate :validate_attachment_content_type,         if: -> { attachment.present? }
    # validate :validate_attachment_size,                 if: -> { attachment.present? }
    # validate :validate_image_dimensions, if: -> { attachment.present? && attachment.dirty? && attachment.content_type != 'video/mp4' }
    # before_save :set_attachment_from_cached_attachment, if: -> { cached_attachment.present? }
    # after_save :remove_cached_attachment,               if: -> { cached_attachment.present? }

  def set_cached_attachment_from_attachment
    self.cached_attachment = if Paperclip::Attachment.default_options[:storage] == :filesystem
                               attachment.path
                             else
                               attachment.url
                             end
  end

  def set_attachment_from_cached_attachment
    self.attachment = if Paperclip::Attachment.default_options[:storage] == :filesystem
                        File.open(cached_attachment)
                      else
                        URI.parse(cached_attachment)
                      end
  end

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

    def documentable_class
      documentable_type.constantize if documentable_type.present?
    end

    def validate_attachment_size
      if documentable_class.present? &&
         attachment_file_size > documentable_class.max_file_size
        errors.add(:attachment, I18n.t("documents.errors.messages.in_between",
                                      min: "0 Bytes",
                                      max: "#{max_file_size(documentable_class)} MB"))
      end
    end

    def validate_attachment_content_type
      if documentable_class &&
         !accepted_content_types(documentable_class).include?(attachment_content_type)
        accepted_content_types = documentable_humanized_accepted_content_types(documentable_class)
        message = I18n.t("documents.errors.messages.wrong_content_type",
                         content_type: attachment_content_type,
                         accepted_content_types: accepted_content_types)
        errors.add(:attachment, message)
      end
    end

    def attachment_presence
      if attachment.blank? && cached_attachment.blank?
        errors.add(:attachment, I18n.t("errors.messages.blank"))
      end
    end

    def remove_cached_attachment
      document = Document.new(documentable: documentable,
                              cached_attachment: cached_attachment,
                              user: user,
                              remove: true,
                              original_filename: title)
      document.set_attachment_from_cached_attachment
      document.attachment.destroy
    end


    def imageable_class
        imageable_type.constantize if imageable_type.present?
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
  
      def attachment_presence
        if attachment.blank? && cached_attachment.blank?
          errors.add(:attachment, I18n.t("errors.messages.blank"))
        end
      end
  
      def attachment_of_valid_content_type?
        attachment.present? && imageable_accepted_content_types.include?(attachment_content_type)
      end
  
      def remove_cached_attachment
        image = Image.new(imageable: imageable,
                          cached_attachment: cached_attachment,
                          user: user)
        image.set_attachment_from_cached_attachment
        image.attachment.destroy
      end
   
end

