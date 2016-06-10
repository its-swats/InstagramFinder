module InstApi
  PROTOCOL = "https://"
  HOST = "api.instagram.com"
  PATH = "/v1/"

  module POSTS
    def self.posts(hashtag, start_date, end_date, pagination = '')
      url_str = url(hashtag, start_date, end_date, pagination)
      posts = get(url_str)
      return JSON.parse(posts.body)
    end

    private

    def self.url(hashtag, start_date, end_date, pagination)
      return PROTOCOL + HOST + PATH + "tags/#{hashtag}/media/recent?access_token=#{SECRET_KEY}&min_timestamp=#{start_date}&max_timestamp=#{end_date}#{pagination}"
    end

    def self.get(url)
      return HTTParty.get(url)
    end

  end

  module COMMENTS
    include HTTParty
    def self.comments(id)
      url_str = url(id)
      comments = get(url_str)
      return JSON.parse(comments.body)
    end

    private

    def self.url(id)
      return PROTOCOL + HOST + PATH + "media/#{id}/comments?access_token=#{SECRET_KEY}"
    end

    def self.get(url)
      return HTTParty.get(url)
    end

  end
end
