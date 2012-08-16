class ImageObserver < ActiveRecord::Observer
  
  def after_create(image)
    if image.is_comment?
      # Comment submitted on owned memory
      if !image.user.eql?(image.memory.user) && image.memory.user.notify?(User::NOTIFY_MEMORY_COMMENT)
        Email.notify_comment_on_owned_memory(image).deliver
      end
      m = image.memory
      m.comments_count += 1
      m.save
      # Comment made by user you are following
      # if image.user.followers.select{|user| user.notify?(User::NOTIFY_COMMENT_MADE_BY_FOLLOWEE)}.count > 0
      #   @followers = image.user.followers
      #   @followers.each do |f|
      #     if f.notify?(User::NOTIFY_COMMENT_MADE_BY_FOLLOWEE)
      #       follower = f
      #       Email.notify_comment_made_by_followee(image, follower).deliver
      #     end
      #   end
      # end
    end
  end
  
  def after_destroy(image)
    m = image.memory
    m.comments_count -= 1
    m.save
  end
  
end