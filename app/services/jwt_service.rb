class JwtService
  SECRET = Rails.application.credentials.secret_key_base

  def self.encode(payload, exp = 24.hours.from_now)
    payload[:exp] = exp.to_i

    return JWT.encode(payload, SECRET, "HS256"), exp
  end

  def self.decode(token)
    decoded = JWT.decode(token, SECRET, true, algorithm: "HS256")
    decoded[0].with_indifferent_access
  rescue JWT::DecodeError
    nil
  end
end
