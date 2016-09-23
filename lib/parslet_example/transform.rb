require 'parslet'

module ParsletExample
  class Transform < Parslet::Transform
    rule(filter_field: simple(:filter_field), range: { lte: simple(:lte) }) do
      {
        filter: {
          range: {
            filter_field => { lte: lte.to_s }
          }
        }
      }
    end

    rule(filter_field: simple(:filter_field), range: { gte: simple(:gte) }) do
      {
        filter: {
          range: {
            filter_field => { gte: gte.to_s }
          }
        }
      }
    end

    rule(filter_field: simple(:filter_field), range: { lte: simple(:lte), gte: simple(:gte) }) do
      {
        filter: {
          range: {
            filter_field => { lte: lte.to_s, gte: gte.to_s }
          }
        }
      }
    end

    rule(filter_field: simple(:filter_field), value: simple(:value)) do
      {
        filter: {
          term: {
            filter_field => value
          }
        }
      }
    end


    rule(match_field: simple(:match_field), value: simple(:value)) do
      {:match => { match_field => value}}
    end

    rule(subqueries: subtree(:subqueries)) do |dict|
      dict = dict[:subqueries]

      output = {
        filtered: {
          query: dict.detect(-> {{match_all: {}}}){ |d| d[:match] },
        }
      }

      filters = dict.map{ |d| d[:filter] }.compact

      if filters.any?
        output[:filtered].merge!(filter: {and: filters})
        output
      else
        output
      end
    end
  end
end
