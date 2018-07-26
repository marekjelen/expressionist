# frozen_string_literal: true

module Expressionist
  module Functions

    add('max') do |context, *segments|
      context.find(segments).max
    end

    add('count') do |context, *segments|
      context.find(segments).length
    end

  end
end