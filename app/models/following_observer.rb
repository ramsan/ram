class FollowingObserver < ActiveRecord::Observer

  def after_create(following)
    Email.notify_user_following_you(following).deliver if following.followee.notify?(User::NOTIFY_FOLLOWED_BY_USER)
  end

end