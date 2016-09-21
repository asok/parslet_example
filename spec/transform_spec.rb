# coding: utf-8
require 'spec_helper'

describe ParsletExample::Transform do
  before do
    $terms = {
      'title'    => {'field' => 'source.artwork.titles.main'},
      'year'     => {'field' => 'source.artwork.date_creation.years_combined'},
      'year_acq' => {'field' => 'source.artwork.date_acquisition.years'},
      'authors'  => {'field' => 'source.authors.name.last'},
      'mode_acq' => {'field' => 'source.artwork.mode_acquisition'}
    }
  end

  subject { described_class.new.apply(input) }

  describe 'single filter' do
    let(:input) do
      {filters: {field: 'title',
                 value: [{literal:  'Ala has a cat'}]}}
    end

    it do
      should eq("and"=>
                  [{"term"=>
                      {"source.artwork.titles.main.keyword"=>
                         "Ala has a cat"}}])
    end
  end

  describe 'many literals' do
    let(:input) do
      {filters: {:field=>"year", :value=>[{:literal=>"1954"},
                                          {:literal=>"1955"},
                                          {:literal=>"1956"}]}}
    end

    it do
      should eq({'and' =>
                 [{"or"=>
                  [{"term"=>
                    {"source.artwork.date_creation.years_combined.keyword"=>"1954"}},
                   {"term"=>
                    {"source.artwork.date_creation.years_combined.keyword"=>"1955"}},
                   {"term"=>
                    {"source.artwork.date_creation.years_combined.keyword"=>"1956"}}]}]})
    end
  end

  describe 'many filters' do
    let(:input) do
      {:filters=>[{field: "title",    value: [{literal: "Étude pour: (\"Les Femmes d'Alger\"), d'après, Delacroix"}]},
                  {field: "year",     value: [{literal: "1954"}]},
                  {field: "year_acq", value: [{literal: "1979"}]},
                  {field: "authors",  value: [{literal: "PICASSO Pablo"}]},
                  {field: "mode_acq", value: [{literal: "Dation"}]}]}
    end

    it do
      should eq('and' =>
                [{"term"=>
                  {"source.artwork.titles.main.keyword"=>"Étude pour: (\"Les Femmes d'Alger\"), d'après, Delacroix"}},
                 {"term"=>{"source.artwork.date_creation.years_combined.keyword"=>"1954"}},
                 {"term"=>{"source.artwork.date_acquisition.years.keyword"=>"1979"}},
                 {"term"=>{"source.authors.name.last.keyword"=>"PICASSO Pablo"}},
                 {"term"=>{"source.artwork.mode_acquisition.keyword"=>"Dation"}}])
    end

  end

  describe 'lte' do
    let(:input) do
      {filters: {field: "year", value: {lte: "1954"}}}
    end

    it do
      should eq({'and' =>
                 [{"range" =>
                   {"source.artwork.date_creation.years" =>
                    {'lte' => "1954"}}}]})
    end
  end

  describe 'gte' do
    let(:input) do
      {filters: {field: "year", value: {gte: "1954"}}}
    end

    it do
      should eq({'and' =>
                 [{"range" =>
                   {"source.artwork.date_creation.years" =>
                    {'gte' => "1954"}}}]})
    end
  end

  describe 'between' do
    let(:input) do
      {filters: {field: "year",
                 value: {lte: '1954',
                         gte: '1956'}}}
    end

    it do
      should eq({'and' =>
                 [{"range" => {"source.artwork.date_creation.years" => {'lte' => "1954", 'gte' => "1956"}}}]})
    end
  end
end
