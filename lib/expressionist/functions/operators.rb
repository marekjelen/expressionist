# frozen_string_literal: true

module Expressionist

  module Functions

    add('>') do |context, left, right|
      left > right
    end

    add('>=') do |context, left, right|
      left >= right
    end

    add('=') do |context, left, right|
      left == right
    end

    add('==') do |context, left, right|
      left == right
    end

    add('!=') do |context, left, right|
      left != right
    end

    add('<=') do |context, left, right|
      left <= right
    end

    add('<') do |context, left, right|
      left < right
    end

  end

end