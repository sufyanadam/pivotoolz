class PostSlackMessage
  def select_webhook_url(url, channel_map, channel)
    return url if channel_map.empty?

    channel_webhook_map = channel_map.split(',').reduce({}) do |reduced, channel_map_string|
      c, url = channel_map_string.split('->')
      reduced[c] = url
      reduced["@#{c}"] = url if !c.start_with?('@')
      reduced["##{c}"] = url if !c.start_with?('#')
      reduced
    end

    channel_webhook_map[channel]
  end

  def post_message(url, channel, content)
    begin
      text, *json = content.split("\n")
      return post_basic_message(url, channel, content) if json.empty?

      post_data = json.any? { |s| s.include? 'blocks' } ? JSON.parse(json.first) : {attachments: json.map { |j| JSON.parse(j) }}
      begin
        RestClient.post(
          url,
          post_data.merge({text: text || ''}).to_json,
          {content_type: :json, accept: :json}
        )
      rescue RestClient::Exceptions => e
        return "Error posting to slack #{e.message}:\n#{e.backtrace}"
      end
    rescue JSON::ParserError => e
      "Error parsing json: #{e}"
    end
  end

  def post_basic_message(url, channel, content)
    begin
      RestClient.post(
        url,
        payload: {
          username: ENV['SLACKBOT_USERNAME'] || 'slackbot',
          channel: channel,
          text: content,
          icon_emoji: ":ghost:"
        }.to_json
      )
    rescue RestClient::Exceptions => e
      puts "Error posting to slack #{e.message}:\n#{e.backtrace}"
    end
  end
end
