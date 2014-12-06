module ApplicationHelper

  def feed_rss_url(feed)
    token_url(feed_path(feed, format: :rss))
  end


  # def torrents_rss_url
  #   token_url(all_torrents_path(format: :rss))
  # end

  def token_url(path)
    rss_uri = URI.parse(request.url)
    rss_uri.path = path
    rss_uri.query = authentication_token_param
    rss_uri.to_s
  end

  def yes_or_no(b)
    b ? 'Yes' : 'No'
  end

  def text_with_icon(text, icon)
    "<span class=\"glyphicon glyphicon-#{icon}\"></span> #{text}".html_safe
  end

  def authentication_token_param
    "authentication_token=#{current_user.authentication_token}"
  end

end
