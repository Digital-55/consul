class CommentNotifier
  def initialize(args = {})
    @comment = args.fetch(:comment)
    @author  = @comment.author
  end

  def process
    send_comment_email
    send_reply_email
  end

  private

  def send_comment_email
    unless @comment.commentable.is_a?(Legislation::Annotation)
      begin
        Mailer.comment(@comment).deliver_now! if email_on_comment?
      rescue => e
        begin
          Rails.logger.error("ERROR-MAILER: #{e}")
        rescue
        end
      end
    end
  end

  def send_reply_email
    begin
      Mailer.reply(@comment).deliver_now! if email_on_comment_reply?
    rescue => e
      begin
        Rails.logger.error("ERROR-MAILER: #{e}")
      rescue
      end
    end
  end

  def email_on_comment?
    commentable_author = @comment.commentable.try(:author)

    commentable_author.present? &&
    commentable_author != @author &&
    commentable_author.email_on_comment?
  end

  def email_on_comment_reply?
    return false unless @comment.reply?

    parent_author = @comment.parent.author
    parent_author != @author && parent_author.email_on_comment_reply?
  end

end
