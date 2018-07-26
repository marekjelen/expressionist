# frozen_string_literal: true

module Expressionist

  class Grammar < Parslet::Parser

    rule(:space) {match('\s').repeat(1)}
    rule(:space?) {space.maybe}

    rule(:lparen) {space? >> str('(') >> space?}
    rule(:rparen) {space? >> str(')') >> space?}

    rule(:comma) {space? >> str(',') >> space?}
    rule(:dot) {space? >> str('.') >> space?}

    rule(:lquote) {space? >> str('"')}
    rule(:rquote) {str('"') >> space?}

    rule(:ande) {space? >> str('AND').as(:boolean_operator) >> space?}
    rule(:ore) {space? >> str('OR').as(:boolean_operator) >> space?}

    rule(:anum) {match('[0-9a-zA-Z]')}
    rule(:anums) {match('[.-_]') >> anum}
    rule(:sanums) {match('[-_]') >> anum}

    rule(:quoted) {(str('\"').as(:char) | (str('"').absent? >> any).as(:char)).repeat}
    rule(:string) {lquote >> quoted.as(:string) >> rquote}
    rule(:integer) {match('[0-9]').repeat(1).as(:integer)}
    rule(:float) {(match('[0-9a-zA-Z]').repeat(1) >> str('.') >> match('[0-9a-zA-Z]').repeat(1)).as(:float)}
    rule(:bool) {(str('true') | str('false')).as(:bool)}

    rule(:keyword) {anum >> (anum | sanums).repeat}

    rule(:segment) { str('*').as(:segment) | str('?').as(:segment) | ((anum >> (anum | sanums).repeat).as(:segment)) }
    rule(:path) {(segment >> (dot >> segment).repeat).as(:path)}

    rule(:func) {keyword.as(:function) >> lparen >> path >> rparen}

    rule(:operator) {str('>=') | str('<=') | str('!=') | str('==') | str('=') | str('<') | str('>')}

    rule(:value) {string | bool | float | integer}

    rule(:expression) do
      space? >>
        (func.as(:func) | path) >>
        space? >>
        operator.as(:operator) >>
        space? >>
        value.as(:value) >>
        space?
    end

    rule(:primary) { lparen >> or_expression >> rparen | expression }

    rule(:and_expression) { (primary.as(:left) >> ande >> and_expression.as(:right)).as(:and) | primary }

    rule(:or_expression) { (and_expression.as(:left) >> ore >> or_expression.as(:right)).as(:or) | and_expression }

    rule(:base) { or_expression }
    # https://github.com/kschiess/parslet/blob/master/example/boolean_algebra.rb

    root(:base)

  end

end