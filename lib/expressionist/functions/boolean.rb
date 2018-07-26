# frozen_string_literal: true

module Expressionist
  module Functions

    add('and') do |context, *items|
      items.inject(true) {|c, i| c && i}
    end

    add('or') do |context, *items|
      items.inject(false) {|c, i| c || i}
    end

  end
end