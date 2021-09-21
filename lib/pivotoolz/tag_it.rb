class TagIt
  def self.call(tag)
    return if tag.nil? || tag.empty?

    timestamp = `date -u +'%Y%m%d%H%M%S'`
    full_tag = "#{tag}/#{timestamp}"
  end
end
