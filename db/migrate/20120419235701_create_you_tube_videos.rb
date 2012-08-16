class CreateYouTubeVideos < ActiveRecord::Migration
  def change
    create_table :you_tube_videos do |t|
      t.string :video_id
      t.references :user, :memory

      t.timestamps
    end
  end
end
