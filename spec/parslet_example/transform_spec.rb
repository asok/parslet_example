require 'spec_helper'

describe ParsletExample::Transform do
  subject do
    described_class.new.apply(input)
  end

  context 'matches by title' do
    let(:input) do
      {subqueries: [{match_field: "title", value: "Count"}]}
    end

    it{ expect(subject).to eq(filtered: {query: {match: {"title" => "Count"}}}) }
  end

  context 'filters by year' do
    let(:input) do
      {subqueries: [{filter_field: "year", value: "1849"}]}
    end

    it{ expect(subject).to eq(filtered: {query: {match_all: {}}, filter: {and: [{term: {"year" => "1849"}}]}}) }
  end

  context 'filters by year range "lte"' do
    let(:input) do
      {subqueries: [{filter_field: "year", range: {lte: "1849"}}]}
    end

    it{ expect(subject).to eq(filtered: {query: {match_all: {}}, filter: {and: [{range: {"year" => {lte: "1849"}}}]}}) }
  end

  context 'filters by year range "gte"' do
    let(:input) do
      {subqueries: [{filter_field: "year", range: {gte: "1849"}}]}
    end

    it{ expect(subject).to eq(filtered: {query: {match_all: {}}, filter: {and: [{range: {"year" => {gte: "1849"}}}]}}) }
  end

  context 'filters by year range "between"' do
    let(:input) do
      {subqueries: [{filter_field: "year", range: {gte: "1845", lte: "1849"}}]}
    end

    it{ expect(subject).to eq(filtered: {query: {match_all: {}}, filter: {and: [{range: {"year" => {lte: "1849", gte: "1845"}}}]}}) }
  end

  context 'matches by title and filters by year range "between"' do
    let(:input) do
      {
        subqueries: [
         {match_field: 'title', value: "Count"},
         {filter_field: "year", range: {gte: "1842", lte: "1845"}}
       ]
      }
    end

    it{
      expect(subject).to eq(filtered: {
                              query: {
                                match: {'title' => "Count"}
                              },
                              filter: {
                                and: [{range: {'year' => {gte: "1842", lte: "1845"}}}]
                              }
                            })
    }
  end
end
