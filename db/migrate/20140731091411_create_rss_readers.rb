class CreateRssReaders < ActiveRecord::Migration
  def change
    create_table :rss_readers do |t|
      t.text :url
      t.text :title

      t.timestamps
    end
  end
end
