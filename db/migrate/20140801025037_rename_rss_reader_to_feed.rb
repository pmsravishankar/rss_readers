class RenameRssReaderToFeed < ActiveRecord::Migration
  def up
    rename_table :rss_readers, :feeds
  end

  def down
    rename_table :feeds, :rss_readers
  end
end
