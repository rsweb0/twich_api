module ApplicationHelper
  def flash_class(level)
    case level
    when 'notice' then 'info'
    when 'error', 'alert' then 'danger'
    end
  end

  def formated_time(time)
    Time.parse(time).strftime("%d %b %Y at %I:%M%p") unless time.blank?
  end

  # the Thumbnail URL has variable height and width
  # i.e "https://static-cdn.jtvnw.net/previews-ttv/live_user_silvername-{width}x{height}.jpg"
  def thumbnail_url(url)
    url.gsub('{width}x{height}', '50x50')
  end

  def twitch_game_path(game_id)
    "https://www.twitch.tv/#{game_id}".html_safe
  end

end
