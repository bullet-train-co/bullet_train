class FerrumConsoleLogger
  def initialize
    @logs = []
  end

  # Filter out the noise - I believe Runtime.exceptionThrown and Log.entryAdded are the interesting log methods but there might be others you need
  def puts(log_str)
    message = Message.new(log_str)
    if %w[Runtime.exceptionThrown Log.entryAdded Runtime.consoleAPICalled].include?(message.method)
      # selenium_compatible_log_message = "#{log_body["params"]["entry"]["url"]} - #{log_body["params"]["entry"]["text"]}"
      # @logs << { message: selenium_compatible_log_message, level: log_body["params"]["entry"]["level"] }
      @logs << message
    end
  end

  def logs(include_unparsed: false)
    if include_unparsed
      @logs
    else
      @logs.reject { |l| l.parser_error? }
    end
  end

  def flush
    @logs = []
  end

  class Message
    attr_reader :body, :body_raw, :parser_error

    def initialize(log_str)
      _symbol, _time, body_raw = log_str.strip.split(" ", 3)
      @body = JSON.parse body_raw
    rescue JSON::ParserError => e
      @parser_error = e
      @body_raw = log_str
    end

    def level
      if method == "Log.entryAdded"
        body.dig "params", "entry", "level"
      else
        body.dig "params", "type"
      end
    end

    def message
      if method == "Log.entryAdded"
        body.dig "params", "entry", "text"
      else
        args = body.dig "params", "args"
        args.map { |h| h["value"] }.join(", ")
      end
    end

    def timestamp
      if method == "Log.entryAdded"
        body.dig "params", "entry", "timestamp"
      else
        body.dig "params", "timestamp"
      end
    end

    def stacktrace
      body.dig "params", "stackTrace"
    end

    def method
      body["method"]
    end

    def parser_error?
      !!parser_error
    end
  end
end
