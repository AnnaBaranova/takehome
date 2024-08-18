module Helpers
  module ErrorHelper
    def self.handle_error(message, exception = nil)
      error_message = message
      error_message += " - #{exception.message}" if exception
      raise error_message
    end
  end
end