Rails.application.config.middleware.use OmniAuth::Builder do  
  #require 'openid/store/filesystem'
  fb_options = {
    :scope => 'email, offline_access, friends_about_me, publish_stream, user_about_me, user_birthday, user_hometown, user_location',
    :display => 'page'
  }
  case Rails.env
    when 'development'
      # provider :facebook, '210370425684806', '7aa003feb8ebfeae032ce0592391b35d',
      provider :facebook, '237063893080853', '457f988eff7ec17d74eb9b71ac5cbfb5',
        {:client_options => {:ssl => {:ca_path => '/etc/ssl/certs'}}}.merge!(fb_options)
      provider :twitter, 'pkST7GXUJ5UYvStBlo7tg', '5v0JJEW15xqkS9UGTgUz1WAkVk2wUFjmpU3c7UZvVdg'
    when 'staging'
      #provider :facebook, '263116157050970', '2e4ffd1061b92a16f7ac0c4b2cdf1784',
      provider :facebook, '237123629741964', 'a1e76127f2ad97dfb75db00d03657195',
        {:client_options => {:ssl => {:ca_path => '/etc/ssl/certs'}}}.merge!(fb_options)
      provider :twitter, 'zrQW0sZ1yQV2N1lph7vQhg', 'xXBJYWT5ELz0IRLiuw8HESEiPLfuE3ovjyhCYBd5fsU'
    when 'production'
      provider :facebook, '450017798344921', '4dbe840ea894732f00e1415dc25d7188',
        {:client_options => {:ssl => {:ca_path => '/etc/ssl/certs'}}}.merge!(fb_options)
      provider :twitter, 'j0CWswfiQnRqnUXLT4Cg', 'lZMsOxivrjcvRqm964j1AIBGGuIws5pZ6bdlmB949mY'
  end       
  #provider :openid, OpenID::Store::Filesystem.new('./tmp'), :name => 'google', :identifier => 'https://www.google.com/accounts/o8/id'     
  provider :openid, :name => 'google', :identifier => 'https://www.google.com/accounts/o8/id'
end