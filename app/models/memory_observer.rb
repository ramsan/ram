class MemoryObserver < ActiveRecord::Observer
  
  def after_create(memory)
    if memory.user.followers.select{|user| user.notify?(User::NOTIFY_MEMORY_ADDED_BY_FOLLOWEE)}.count > 0 && !memory.is_anonymous?
      @followers = memory.user.followers
      @followers.each do |f|
        if f.notify?(User::NOTIFY_MEMORY_ADDED_BY_FOLLOWEE)
          follower = f
          Email.notify_memory_added_by_followee(memory, follower).deliver
        end
      end
    end
  end
  
end
