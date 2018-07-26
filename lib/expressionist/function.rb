# frozen_string_literal: true

module Expressionist

  class Function

    attr_reader :name, :args

    def initialize(name, *args)
      if name.kind_of?(Array) && args.length == 0
        @name = name[0]
        @args = name[1..-1].map do |arg|
          arg.kind_of?(Array) ? Function.new(arg) : arg
        end
      else
        @name = name
        @args = args
      end
    end

    def to_a
      [name] + args.map { |arg| arg.kind_of?(Function) ? arg.to_a : arg }
    end

    def to_s
      "#{name}(#{args.map(&to_s).join(', ')})"
    end

    def ==(other)
      self.class == other.class && other.name == self.name && other.args == self.args
    end

  end

end