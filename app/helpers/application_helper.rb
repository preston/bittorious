module ApplicationHelper

	def as_size( s )
		prefix = %W(TiB GiB MiB KiB B)
		s = s.to_f
		i = prefix.length - 1
		while s > 512 && i > 0
		  s /= 1024
		  i -= 1
		end
	((s > 9 || s.modulo(1) < 0.1 ? '%d' : '%.1f') % s) + ' ' + prefix[i]
	end

  def attachment_url(file, style = :original)
    "#{request.protocol}#{request_host_or_default}#{file.url(style)}"
  end

  def request_host_or_default
    request.host_with_port.match(/localhost/) ? AppConfig['default_hostname'].gsub(/:\d+/,'') : request.host_with_port
  end

  def feed_rss_url(feed)
    rss_url(url_for(feed) + '.rss')
    # url_for(feed) + '.rss'
  end

  def torrents_rss_url
    rss_url(torrents_path(:format => :rss))
    # url_for(torrents_path(:format => :rss))
  end

  def rss_url(path)
    rss_uri = URI.parse(request.url)
    rss_uri.path = path
    rss_uri.query = "user_token=#{current_user.authentication_token}"
    rss_uri.to_s
  end

  def yes_or_no(b)
    b ? 'Yes' : 'No'
  end

  def text_with_icon(text, icon)
    "<i class=\"icon-white icon-#{icon}\"></i> #{text}".html_safe
  end

end
