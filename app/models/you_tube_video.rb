=begin
  create_table 'you_tube_videos', :force => true do |t|
    t.string   'video_id'
    t.integer  'user_id'
    t.integer  'memory_id'
    t.datetime 'created_at'
    t.datetime 'updated_at'
  end  
=end

class YouTubeVideo < ActiveRecord::Base
  belongs_to :user
  belongs_to :memory
  
  attr_accessor :url

  validates_presence_of :user_id, :video_id #:memory_id,  
  
  before_validation :extract_id_from_url
  
  def iframe_preview
    iframe_html(CONFIG[:you_tube_video][:preview][:w],CONFIG[:you_tube_video][:preview][:h])
  end
  
  def iframe_full
    iframe_html(CONFIG[:you_tube_video][:full][:w],CONFIG[:you_tube_video][:full][:h])
  end
    
  def extract_id_from_url
    if !url.blank?
      vid = ''
      uri = URI.parse(URI.extract(url).first)
      case uri.host
        when /youtube\.com/ #http://www.youtube.com/watch?v=7f3eS72pIgU
          vid = CGI.parse(uri.query)['v'].first
        when /youtu\.be/ #http://youtu.be/7f3eS72pIgU
          vid = uri.path.split('/').pop
      end
      self.video_id = vid if !vid.blank?
      Rails.logger.debug "YouTubeVideo.video_id = #{self.video_id}"
    else
      Rails.logger.debug "YouTubeVideo.video_id NOT SET"
    end
  end
  
  private
  
  def iframe_html(w,h)
    "<iframe width='#{w}' height='#{h}' src='http://www.youtube.com/embed/#{video_id}&showsearch=0&rel=0' frameborder='0' allowfullscreen></iframe>"
  end
  
end
