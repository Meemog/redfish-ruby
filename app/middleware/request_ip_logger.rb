class RequestIpLogger
  def initialize(app)
    @app = app
  end

  def call(env)
    request = ActionDispatch::Request.new(env)

    Rails.logger.info(
      "Request IP=#{request.remote_ip} " \
      "ForwardedFor=#{request.headers['X-Forwarded-For']} " \
      "Path=#{request.path}"
    )

    @app.call(env)
  end
end
