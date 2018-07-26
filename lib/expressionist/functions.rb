# frozen_string_literal: true

module Expressionist

  module Functions

    class << self

      def functions
        @functions ||= {}
      end

      def add(name, &block)
        functions[name] = block
      end

      def get(name)
        functions[name]
      end

    end

  end

end

require 'expressionist/functions/core'
require 'expressionist/functions/operators'
require 'expressionist/functions/boolean'
require 'expressionist/functions/math'