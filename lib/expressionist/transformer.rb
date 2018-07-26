# frozen_string_literal: true

module Expressionist

  class Transformer < Parslet::Transform

    rule(integer: simple(:value)) { Integer(value) }
    rule(float: simple(:value)) { Float(value) }
    rule(integer: simple(:value)) { Integer(value) }
    rule(bool: simple(:value)) { ['false'].include?(value) ? false : true }

    rule(char: simple(:value)) { value == '\\"' ? '"' : value }
    rule(string: sequence(:value)) { value.join }

    rule(segment: simple(:value)) { value.str }

    rule(path: sequence(:value)) { value }
    rule(path: simple(:value)) { value }

    rule(function: simple(:name), path: simple(:path)) do
      Function.new(name.str, path)
    end

    rule(function: simple(:name), path: sequence(:path)) do
      Function.new(name.str, *path)
    end

    rule(operator: simple(:op), value: simple(:value), func: simple(:func)) do
      Function.new(op.str, func, value)
    end

    rule(operator: simple(:op), value: simple(:value), path: simple(:path)) do
      Function.new(op.str, Function.new('get', path), value)
    end

    rule(operator: simple(:op), value: simple(:value), path: sequence(:path)) do
      Function.new(op.str, Function.new('get', *path), value)
    end

    rule(expression: simple(:value)) { value }

    rule(boolean_operator: simple(:value), left: simple(:left), right: simple(:right)) do
      Function.new(value.str.strip.downcase, left, right)
    end

    rule(and: simple(:value)) { value }
    rule(or: simple(:value)) { value }

  end

end