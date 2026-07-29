class ApiErrorHandler
  def initialize(app)
    @app = app
  end

  def call(env)
    @app.call(env)
  rescue StandardError => e
    Rails.error.report(e)

    [
      500,
      { "Content-Type" => "application/json" },
      [
        {
          error: "INTERNAL_SERVER_ERROR",
          message: "An unexpected error occurred."
        }.to_json
      ]
    ]
  end
end
