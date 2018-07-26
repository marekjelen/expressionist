# frozen_string_literal: true

require 'test_helper'

class ExpressionistTest < Minitest::Test

  def check(expr, result = nil, opts = {})
    opts[:correct] = true unless opts.key?(:correct)

    context = Expressionist::Context.new
    context['key'] = 'value'
    context['abc-ppp.hh-y'] = '5'
    context['abc'] = 'va"lue'
    context['abcd'] = '10'
    context['yip-top'] = '10'
    context['x'] = '2.0'
    context['t'] = 'true'
    context['tmp'] = '6'
    context['a.b.c'] = '1'
    context['a.d.e'] = '2'
    context['a.e'] = '3'
    context['a.f.c'] = '4'

    unless opts[:correct]
      assert_raises(ArgumentError) { Expressionist.compile(expr).call(context) }
      return
    end

    expression = Expressionist.compile(expr)

    parser = expression.instance_variable_get('@parser')

    assert_equal(parser.compiled, Expressionist::Function.new(parser.executable))
    assert_equal(result, parser.compiled) if result
    assert(expression.call(context), expr)
  end

  def mand(*args)
    Expressionist::Function.new('and', *args)
  end

  def mor(*args)
    Expressionist::Function.new('or', *args)
  end

  def mexpr(left, op, right)
    Expressionist::Function.new(op, Expressionist::Function.new('get', *left.split('.')), right)
  end

  def mfunc(f, key, op, right)
    Expressionist::Function.new(op, Expressionist::Function.new(f, *key.split('.')), right)
  end

  def test_simple
    check('key="value"', mexpr('key', '=', 'value'))
    check('abc-ppp.hh-y=5', mexpr('abc-ppp.hh-y', '=', 5))
    check('  abc =     "va\\"lue" ', mexpr('abc', '=', 'va"lue'))
    check('  t = true ', mexpr('t', '=', true))
  end

  def test_incorrect
    check('abc--ppp.hh-y="value"', nil, correct: false)
    check('-abc="value"', nil, correct: false)
    check('cde.="value"', nil, correct: false)
    check('.-h-="value"', nil, correct: false)
    check('a-="value"', nil, correct: false)
    check('-="value"', nil, correct: false)
  end

  def test_functions
    check('count(*)=12', mfunc('count', '*', '=', 12))
    check('count(?)=7', mfunc('count', '?', '=', 7))
    check('count(a.?.c)=2', mfunc('count', 'a.?.c', '=', 2))
    check('count(a.b.?)=1', mfunc('count', 'a.b.?', '=', 1))
    check('count(a.*)=4', mfunc('count', 'a.*', '=', 4))
    check('count(*.c)=2', mfunc('count', '*.c', '=', 2))
    check('max(abc-ppp.hh-y)=5', mfunc('max', 'abc-ppp.hh-y', '=', 5))
    check('max   ( abc-ppp.hh-y    ) =    5', mfunc('max', 'abc-ppp.hh-y', '=', 5))
  end

  def test_operators
    check('count(key) <  5', mfunc('count', 'key', '<',  5))
    check('count(key) <= 5', mfunc('count', 'key', '<=', 5))
    check('count(key) =  1', mfunc('count', 'key', '=',  1))
    check('count(key) == 1', mfunc('count', 'key', '==',  1))
    check('count(key) >= 1', mfunc('count', 'key', '>=', 1))
    check('count(key) >  0', mfunc('count', 'key', '>',  0))
    check('count(key) != 2', mfunc('count', 'key', '!=', 2))
  end

  def test_superexpressions
    check('abcd = 10 AND x == 2.0', mand(mexpr('abcd', '=', 10), mexpr('x', '==', 2)))
    check('abcd = 10 OR (count(t) = 3 AND max(tmp) = 6)',
          mor(mexpr('abcd', '=', 10), mand(mfunc('count', 't', '=', 3), mfunc('max', 'tmp', '=', 6))))
    check('abcd = 10 AND (count(t) = 1 AND max(tmp) = 6)',
          mand(mexpr('abcd', '=', 10), mand(mfunc('count', 't', '=', 1), mfunc('max', 'tmp', '=', 6))))
  end

end
