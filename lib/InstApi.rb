module InstApi
  PROTOCOL = "https://"
  HOST = "api.instagram.com"
  PATH = "/v1/"
  NEXT_PAGE = "&max_tag_id="


  module POSTS
    def self.posts(hashtag, start_date, end_date, closest_start='')
      return collect_all_posts(hashtag, start_date, end_date, closest_start)
    end

    private

    def self.collect_all_posts(hashtag, start_date, end_date, closest_start)
      next_page = closest_start
      all_posts = []
      loop do 
        url_str = url(hashtag, next_page)
        new_posts = get(url_str)
        new_posts['data'].each {|post| post['pointer'] = "#{NEXT_PAGE}#{new_posts['pagination']['next_max_tag_id']}"}
        all_posts << new_posts.parsed_response['data']
        next_page = "#{NEXT_PAGE}#{new_posts.parsed_response['pagination']['next_max_tag_id']}"
        break if pagination_is_done?(new_posts, start_date)
      end
      return trim_dates(all_posts.flatten(1), start_date, end_date)
    end

    def self.pagination_is_done?(new_post, start_date)
      return new_post.parsed_response['data'][-1]['created_time'].to_i < start_date || !new_post.parsed_response['pagination']['next_max_tag_id']
    end

    def self.trim_dates(all_posts, start_date, end_date)
      return all_posts.reject{|post| post['created_time'].to_i < (start_date) || post['created_time'].to_i > (end_date)}
    end

    def self.url(hashtag, pagination)
      return PROTOCOL + HOST + PATH + "tags/#{hashtag}/media/recent?access_token=#{SECRET_KEY}#{pagination}"
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



