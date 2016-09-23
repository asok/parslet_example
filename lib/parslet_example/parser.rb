require 'parslet'

module ParsletExample
  class Parser < Parslet::Parser
    def year(name)
      match('[0-9]').repeat(4).as(name)
    end

    rule(:match_field) do
      str('title')
    end

    rule(:filter_field) do
      str('year')
    end

    rule(:value) do
      (str(',,').absent? >> any).repeat
    end

    rule(:lte) do
      str('__') >> year(:lte)
    end

    rule(:gte) do
      year(:gte) >> str("__")
    end

    rule(:between) do
      year(:gte) >> str("__") >> year(:lte)
    end

    rule(:range) do
      between | lte | gte
    end

    rule(:subquery) do
      (match_field.as(:match_field) | filter_field.as(:filter_field)) >>
        str(':') >>
        (range.as(:range) | value.as(:value))
    end

    rule(:subqueries) do
      (subquery >> (str(',,') >> subquery).repeat(0)).repeat(1).as(:subqueries)
    end

    root(:subqueries)
  end
end
