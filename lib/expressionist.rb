# frozen_string_literal: true

require 'parslet'

require 'expressionist/version'
require 'expressionist/context'
require 'expressionist/expression'
require 'expressionist/parser'

module Expressionist

  def self.compile(expression)
    Expression.new(Parser.new(expression))
  end

end