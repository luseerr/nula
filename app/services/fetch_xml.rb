class FetchXml

  def yt_urls
    youtube_urls
  end

  private

  def parse_xml_entries
    Feedjira::Feed.fetch_and_parse("http://www.radionula.com/rss.xml").entries
  end

  def get_songs
    songs_list = []
    parse_xml_entries.each do |s|
      songs_list.push(s.title) if s.title != "Photo"
    end
    songs_list
  end

  def get_authors
    authors_list = []
    get_songs.each do |author|
      authors_list.push(author.sub(/\s-\s.*/, ''))
    end
    authors_list
  end

  def get_titles
    titles_list = []
    get_songs.each do |title|
      titles_list.push(title.sub(/.*\s-\s/, ''))
    end
    titles_list
  end

  def youtube_client
    client = YouTubeIt::Client.new(dev_key: "AIzaSyBb37FdGRmySFAQZ2aH06bysPQfwBYiBiw")
  end

  def youtube_urls
    videos_list = []
    get_songs.each do |song|
      videos_list.push(youtube_client.videos_by(query: song, per_page: 5))
    end
    urls_list = []
    videos_list.each do |url|
      unless url.videos.count == 0
        urls_list.push(url.videos.first.player_url)
      else
        urls_list.push("Not found on youtube")
      end
    end
    titles_list = []
    videos_list.each do |url|
      unless url.videos.count == 0
        titles_list.push(url.videos.first.title)
      else
        titles_list.push("Not found on youtube")
      end
    end
    thumbnails_list = []
    videos_list.each do |thumbnail|
      unless thumbnail.videos.count == 0
        thumbnails_list.push(thumbnail.videos.first.thumbnails.fifth.url)
      else
        thumbnails_list.push("Image not found")
      end
    end
    urls_list.zip titles_list, thumbnails_list
  end

end
