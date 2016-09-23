require 'spec_helper'

describe ParsletExample::Parser do
  subject do
    described_class.new.parse(input)
  end

  context 'matches by title' do
    let(:input) do
      "title:Count"
    end

    it{ expect(subject).to eq(subqueries: [{match_field: "title", value: "Count"}]) }
  end

  context 'filters by year' do
    let(:input) do
      "year:1984"
    end

    it{ expect(subject).to eq(subqueries: [{filter_field: "year", value: "1984"}]) }
  end

  context 'filters by year range "lte"' do
    let(:input) do
      "year:__1845"
    end

    it{ expect(subject).to eq(subqueries: [{filter_field: "year", range: {lte: "1845"}}]) }
  end

  context 'filters by year range "gte"' do
    let(:input) do
      "year:1845__"
    end

    # it{ expect(subject).to include(filters: {range: {field: "year", gte: "1845"}}) }
    it{ expect(subject).to eq(subqueries: [{filter_field: "year", range: {gte: "1845"}}]) }
  end

  context 'filters by year range "between"' do
    let(:input) do
      "year:1842__1845"
    end

    it{ expect(subject).to include(subqueries: [{filter_field: "year", range: {gte: "1842", lte: "1845"}}]) }
  end

  context 'matches by title and filters by year range "between"' do
    let(:input) do
      "title:Count,,year:1842__1845"
    end

    it{
      expect(subject).to eq(
                           subqueries:
                             [
                               {:match_field=>"title", :value=>"Count"},
                               {:filter_field=>"year", :range=>{:gte=>"1842",
                                                                :lte=>"1845"}}
                             ]

                           )
    }
  end
end
