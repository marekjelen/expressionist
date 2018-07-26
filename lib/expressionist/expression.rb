# frozen_string_literal: true

require 'expressionist/function'
require 'expressionist/functions'

module Expressionist

  class Expression

    def initialize(value)
      if value.kind_of?(Parser)
        @parser = value
      else
        @executable = value
      end
    end

    def executable
      @executable ||= @parser.executable
    end

    def call(context = {}, executable = nil)
      executable ||= self.executable

      args = executable[1..-1].map do |exp|
        if exp.kind_of?(Array)
          call(context, exp)
        else
          exp
        end
      end

      function = Functions.get(executable[0])
      unless function
        raise ArgumentError, "Function #{executable[0].inspect} is missing"
      end

      function.call(context, *args)
    end

  end

end