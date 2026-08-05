require "digest"

class Hasher
  def self.call(password)
    Digest::SHA256.hexdigest(password)
  end
end
