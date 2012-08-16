Dyr::Application.configure do
  # OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE
  # Settings specified here will take precedence over those in config/application.rb

  # Code is not reloaded between requests
  config.cache_classes = true

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Disable Rails's static asset server (Apache or nginx will already do this)
  config.serve_static_assets = false

  # Compress JavaScripts and CSS
  config.assets.compress = true

  # Specify the default JavaScript compressor
  config.assets.js_compressor  = :uglifier

  # Specifies the header that your server uses for sending files
  # (comment out if your front-end server doesn't support this)
  config.action_dispatch.x_sendfile_header = "X-Sendfile" # Use 'X-Accel-Redirect' for nginx

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  # config.force_ssl = true

  # See everything in the log (default is :info)
  config.log_level = :debug

  # Use a different logger for distributed setups
  # config.logger = SyslogLogger.new

  # Use a different cache store in production
  # config.cache_store = :mem_cache_store

  # Enable serving of images, stylesheets, and JavaScripts from an asset server
  # config.action_controller.asset_host = "http://assets.example.com"

  # Precompile additional assets (application.js, application.css, and all non-JS/CSS are already added)
  # config.assets.precompile += %w( search.js )

  # Disable delivery errors, bad email addresses will be ignored
  #config.action_mailer.default_url_options = { :host => 'dyr.minerva-group.com' } # for Devise
  #config.action_mailer.raise_delivery_errors = false
  #config.action_mailer.delivery_method = :smtp
  #config.action_mailer.smtp_settings = {
  #  :user_name => "minerva-group",
  #  :password => "mg2007",
  #  :domain => "dyr.minerva-group.com",
  #  :address => "smtp.sendgrid.net",
  #  :port => 587,
  #  :authentication => :plain,
  #  :enable_starttls_auto => true
  #}
  config.assets.precompile += %w( style.css splash.css entrance.css entrance.js birthyear.css sign_in_up.css notifications.css )

  # Disable delivery errors, bad email addresses will be ignored
  config.action_mailer.default_url_options = { :host => 'doyouremember.com' } # for Devise
  config.action_mailer.raise_delivery_errors = false
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    :user_name => "AKIAJBQHMDXOVWFCME3Q",
    :password => "Av5jS1HrIITkaSwIFPLVeU8j3oyWTRHtbdn1gCbN1Va1",
    :domain => "doyouremember.com",
    :address => "email-smtp.us-east-1.amazonaws.com",
    :port => 587,
    #:authentication => :plain,
    :enable_starttls_auto => true
  } 
  
  # Enable threaded mode
  # config.threadsafe!

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify
end
