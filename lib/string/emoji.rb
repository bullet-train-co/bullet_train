class String
  def strip_emojis
    gsub(Unicode::Emoji::REGEX, "")
  end

  def only_emoji?
    return false if strip.empty?
    strip_emojis.strip.empty?
  end
end
