require 'parslet'

module ParsletExample
  class Transform < Parslet::Transform
    field_name = lambda do |name|
      "#{$terms[name.to_s]['field']}.keyword"
    end
    YearFieldName = 'source.artwork.date_creation.years'

    rule(literal: simple(:literal)) do
      literal.to_s
    end

    rule(field: simple(:field), value: { lte: simple(:lte) }) do
      { 'range' =>
        { YearFieldName => { 'lte' => lte.to_s } } }
    end

    rule(field: simple(:field), value: { gte: simple(:gte) }) do
      { 'range' =>
        { YearFieldName => { 'gte' => gte.to_s } } }
    end

    rule(field: simple(:field), value: { lte: simple(:lte),
                                         gte: simple(:gte) }) do
      { 'range' =>
        { YearFieldName => { 'lte' => lte.to_s, 'gte' => gte.to_s } } }
    end

    rule(field: simple(:field), value: sequence(:literals)) do
      if literals.one?
        { 'term' => { field_name.call(field) => literals.first } }
      else
        { 'or' =>
          literals.map do |literal|
            { 'term' => { field_name.call(field) => literal } }
          end
        }
      end
    end

    rule(filters: subtree(:filters)) do |dict|
      filters = dict[:filters]
      filters = Array[filters] unless filters.is_a? Array
      { 'and' => filters }
    end

    rule(filters: subtree(:filters), ids: subtree(:ids)) do |dict|
      filters = dict[:filters]
      filters = Array[filters] unless filters.is_a? Array
      { 'and' => filters.push(ids: { values: dict[:ids] }) }
    end

    rule(ids: subtree(:ids)) do
      { ids: { values: ids } }
    end

    rule('') do
      { 'match_all' => {} }
    end
  end
end
