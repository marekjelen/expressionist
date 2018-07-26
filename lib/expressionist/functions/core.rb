# frozen_string_literal: true

module Expressionist
  module Functions

    add('get') do |context, *segments|
      context.find(segments).first
    end

  end
end