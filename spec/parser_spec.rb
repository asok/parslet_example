# coding: utf-8
require_relative 'spec_helper'

describe ParsletExample::Parser do
  subject { described_class.new.parse(input) }

  describe 'literal year' do
    let(:input){ "year:1954" }
    it{ should eq(filters: {field: "year", value: [{literal: "1954"}]}) }
  end

  describe 'lte year' do
    let(:input){ "year:__1954" }
    it{ should eq(filters: {field: "year",
                            value: {lte: "1954"}}) }
  end

  describe 'gte year' do
    let(:input){ "year:1954__" }
    it{ should eq(filters: {field: "year",
                            value: {gte: "1954"}}) }
  end

  describe 'between years' do
    let(:input){ "year:1954__1956" }
    it{ should eq(filters: {field: "year",
                            value: {gte: "1954", lte: "1956"}}) }
  end

  describe 'literal year' do
    let(:input){ "year:1954" }
    it{ should eq(filters: {field: "year", value: [{literal: "1954"}]}) }
  end

  describe 'many literals' do
    let(:input){ 'year:1954||1955||1956' }
    it do
      should eq(filters: {:field=>"year", :value=>[{:literal=>"1954"},
                                                   {:literal=>"1955"},
                                                   {:literal=>"1956"}]})
    end
  end

  describe 'catching literal' do
    describe 'with ,' do
      let(:input){ "title:Ala has a cat, and the cat has Ala" }
      it do
        should eq(filters: {field: 'title',
                            value: [{literal:  'Ala has a cat, and the cat has Ala'}]})
      end
    end

    describe 'with single ;' do
      let(:input){ "title:Ala has a cat;and the cat has Ala" }
      it do
        should eq(filters: {field: 'title',
                            value: [{literal: 'Ala has a cat;and the cat has Ala'}]})
      end
    end

    describe 'with double ||' do
      let(:input){ "title:Ala has a cat||and the cat has Ala" }
      it do
        should eq(filters: {field: 'title',
                            value: [{literal: 'Ala has a cat'},
                                    {literal: 'and the cat has Ala'}]})
      end
    end

    describe 'with ; at the end' do
      let(:input){ "title:Ala has a cat and the cat has Ala;" }
      it do
        should eq(filters: {field: 'title',
                            value: [{literal: 'Ala has a cat and the cat has Ala;'}]})
      end
    end

    describe 'with , at the end' do
      let(:input){ "title:Ala has a cat and the cat has Ala," }
      it do
        should eq(filters: {field: 'title',
                            value: [{literal: 'Ala has a cat and the cat has Ala,'}]})
      end
    end
  end

  describe 'many filters' do
    let(:input) do
      %Q{title:Étude pour: (\"Les Femmes d'Alger\"), d'après, Delacroix,,year:1954,,year_acq:1979,,authors:PICASSO Pablo,,mode_acq:Dation}
    end
    it{ should eq(:filters=>[{field: "title",    value: [{literal: "Étude pour: (\"Les Femmes d'Alger\"), d'après, Delacroix"}]},
                             {field: "year",     value: [{literal: "1954"}]},
                             {field: "year_acq", value: [{literal: "1979"}]},
                             {field: "authors",  value: [{literal: "PICASSO Pablo"}]},
                             {field: "mode_acq", value: [{literal: "Dation"}]}]) }
  end
end
