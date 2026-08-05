class RefreshService
  def self.generate(user)
    token = SecureRandom.hex(64)
    hash = Hasher.call(token)
    exp = 7.days.from_now

    user.refresh_tokens.create!(
      tokenHash: hash,
      expiry: exp
    )

    return token, exp
  end

  def self.authenticate(token)
    token_hash = Hasher.call(token)

    refresh_token = RefreshToken.find_by(tokenHash: token_hash)

    return nil unless refresh_token
    return nil if refresh_token.expiry < Time.current

    refresh_token.user
  end
end
