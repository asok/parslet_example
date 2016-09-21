# coding: utf-8
require 'parslet'

module ParsletExample
  class Parser < Parslet::Parser
    def year(name)
      match('[0-9]').repeat(4).as(name)
    end

    rule(:empty) { str('') }
    rule(:field) { match('[a-z_0-9]').repeat(1) }
    rule(:between) { year(:gte) >> str('__') >> year(:lte) }
    rule(:lte) { str('__') >> year(:lte) }
    rule(:gte) { year(:gte) >> str('__') }
    rule(:year_range) do
      between | lte | gte
    end
    rule(:literal) do
      (str(',,').absent? >> str('||').absent? >> any).repeat(1).as(:literal)
    end
    rule(:literals) do
      literal >> (str('||') >> literal).repeat(0)
    end
    rule(:value) do
      year_range | literals.repeat(1)
    end
    rule(:filter) do
      field.as(:field) >> str(':') >> value.as(:value)
    end
    rule(:filters) do
      (filter >> (str(',,') >> filter).repeat(0)).as(:filters) | empty
    end

    root(:filters)
  end
end
