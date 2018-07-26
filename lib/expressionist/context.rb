# frozen_string_literal: true

module Expressionist

  class Context

    def initialize(data = {})
      @data = data
    end

    def []=(key, value)
      segments = key.split('.')
      len = segments.length
      data = @data
      (0...len).each do |i|
        key = segments[i]
        data = (data[key] ||= {})
      end
      data['.'] = value
    end

    def delete(key)
      segments = key.split('.')
      len = segments.length
      data = @data
      (0...len).each do |i|
        break unless data
        data = data[segments[i]]
      end
      data.delete('.') if data
    end

    def [](key)
      find(key.split('.'), @data)
    end

    def find(segments = [], data = nil)
      data ||= @data
      segment = segments[0]
      subsegments = segments[1..-1]

      case
      when data == nil
        [nil]
      when segments.length == 0
        [cast(data['.'])]
      when segment == '?'
        (data.keys - ['.']).map do |k|
          find(subsegments, data[k])
        end
      when segment == '*' && subsegments.length > 0 && data[subsegments[0]]
        find(subsegments[1..-1], data[subsegments[0]])
      when segment == '*'
        (subsegments.length == 0 ? [data['.']] : []) + (data.keys - ['.']).map do |k|
          find(segments, data[k])
        end
      else
        find(subsegments, data[segment])
      end.flatten.compact
    end

    def export
      @data
    end

    def cast(value)
      case value
      when 'true'
        true
      when 'false'
        false
      when /[0-9]+[.,][0-9]+/
        Float(value)
      when /[0-9]+/
        Integer(value)
      else
        value
      end
    end

  end

end