# Helper module to handle errors
#
# This module provides utility methods to handle errors in a consistent way.
# It includes the ability to raise an error with a custom message and optional exception.
#
# Methods:
# - handle_error(message, exception): Handle an error by raising an exception with a custom message.

module Helpers
  module ErrorHelper
    # Handle an error by raising an exception with a custom message
    # @param message [String] the error message
    # @param exception [Exception] the optional exception that caused the error
    # @raise [StandardError] with the custom error message

    def self.handle_error(message, exception = nil)
      error_message = message
      error_message += " - #{exception.message}" if exception
      raise error_message
    end
  end
end