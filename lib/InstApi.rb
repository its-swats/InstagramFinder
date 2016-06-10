module InstApi
  PROTOCOL = "https://"
  HOST = "api.instagram.com"
  PATH = "/v1/"

  module POSTS
    
    def self.posts(hashtag, secret_key, start_date, end_date, pagination = '')
      url_str = url(hashtag, secret_key, start_date, end_date, pagination)
      posts = get(url)
      return JSON.parse(posts).body
    end

    private

    def self.url(hashtag, secret_key, start_date, end_date, pagination = '')
      return PROTOCOL + HOST + PATH + "tags/#{hashtag}/media/recent?access_token=#{secret_key}&min_timestamp=#{start_date}&max_timestamp=#{end_date}#{pagination}"
    end

    def self.get(url)
      return HTTParty(url)
    end

  end

  module COMMENTS

    def self.comments
      url_str = url(id, secret_key)
      comments = get(url)
      return JSON.parse(comments).body
    end

    private

    def self.url(id, secret_key)
      return PROTOCOL + HOST + PATH + "media/#{id}/comments?access_token=#{secret_key}"
    end

    def sefget(url)
      return HTTParty(url)
    end

  end
end
