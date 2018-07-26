# frozen_string_literal: true

require 'expressionist/grammar'
require 'expressionist/transformer'

module Expressionist

  class Parser

    def initialize(expression)
      @parsed = nil
      @compiled = nil
      @executable = nil

      case expression
      when String
        @expression = expression
      when Function
        @compiled   = expression
      when Array
        @executable = expression
      else
        raise ArgumentError, "Unknown expression type: #{expression}"
      end
    end

    def parsed
      raise RuntimeError, 'Expression was not passed' unless @expression
      @parsed ||= Grammar.new.parse(@expression)
    rescue Parslet::ParseFailed => e
      # puts expression
      # puts e.parse_failure_cause.ascii_tree
      raise ArgumentError, "Invalid expression: #{@expression}"
    end

    def compiled
      raise RuntimeError, 'Raw nor compiled form was passed' unless @compiled || parsed
      @compiled ||= Transformer.new.apply(parsed)
    end

    def executable
      raise RuntimeError, 'Compiled nor executable form was passed' unless @executable || compiled
      @executable ||= compiled.to_a
    end

  end

end