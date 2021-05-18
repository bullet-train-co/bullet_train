module ObfuscatesId
  extend ActiveSupport::Concern

  class_methods do
    def hashids
      # ⚠️ Changing anything in this method will invalidate any URLs with obfuscated IDs that are in the wild.
      # You should not change any of these settings after going live unless you're OK breaking links in sent emails,
      # breaking bookmarks to pages within your application, etc. For this reason, we don't want the Hashids salt
      # configurable via an ENV value.

      # We don't include digits in our alphabet because it sometimes results in fully numeric strings being generated,
      # and we can't differentiate those from normal IDs that we still need to be able to deal with.
      @hashids ||= Hashids.new "Default ID Obfuscation Salt for #{name}", 6, "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
    end

    def encode_id(id)
      hashids.encode(id)
    end

    def decode_id(id)
      return id if id.to_i > 0
      hashids.decode(id).first
    end

    def find(*ids)
      super(*ids.map { |id| decode_id(id) })
    end

    def relation
      super.tap { |r| r.extend ClassMethods }
    end

    def has_many(*args, &block)
      options = args.extract_options!
      options[:extend] = Array(options[:extend]).push(ClassMethods)
      super(*args, **options, &block)
    end

    def find_by_obfuscated_id(id)
      find_by(id: decode_id(id))
    end
  end

  def obfuscated_id
    @obfuscated_id ||= self.class.encode_id(id)
  end

  def to_param
    obfuscated_id
  end
end
