# https://makandracards.com/makandra/24449-hash-any-ruby-object-into-an-rgb-color
module Colorizer
  extend self

  def colorize(object)
    # Inspired by Jeremy Ruten (http://stackoverflow.com/questions/1698318/ruby-generate-a-random-hex-color)
    hash = object.hash # hash an object, returns a Fixnum
    trimmed_hash = hash & 0xffffff # trim the hash to the size of 6 hex digits (& is bit-wise AND)
    hex_code = "%06x" % trimmed_hash # format as at least 6 hex digits, pad with zeros
    "##{hex_code}"
  end

  def colorize_similarly(object, saturation, lightness)
    rnd = ((object.hash * 7) % 100) * 0.01
    hsl_to_rgb(rnd, saturation, lightness)
  end

  private

  def hsl_to_rgb(h, sl, l)
    r = l
    g = l
    b = l
    v = l <= 0.5 ? (l * (1.0 + sl)) : (l + sl - l * sl)
    if v > 0
      m = l + l - v
      sv = (v - m) / v
      h *= 6.0
      sextant = h.floor
      fract = h - sextant
      vsf = v * sv * fract
      mid1 = m + vsf
      mid2 = v - vsf
      case sextant
      when 0
        r = v
        g = mid1
        b = m
      when 1
        r = mid2
        g = v
        b = m
      when 2
        r = m
        g = v
        b = mid1
      when 3
        r = m
        g = mid2
        b = v
      when 4
        r = mid1
        g = m
        b = v
      when 5
        r = v
        g = m
        b = mid2
      end
    end
    "##{hex_color_component(r)}#{hex_color_component(g)}#{hex_color_component(b)}"
  end

  def hex_color_component(i)
    (i * 255).floor.to_s(16).rjust(2, "0")
  end
end
