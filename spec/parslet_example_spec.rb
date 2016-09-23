require 'spec_helper'
require 'elasticsearch'

describe ParsletExample do
  def client
    Elasticsearch::Client.new
  end

  before(:all) do
    client.index  index: 'books', type: 'book', id: 1, body: { title: 'Count Monte Christo', year: "1844"}
    client.index  index: 'books', type: 'book', id: 2, body: { title: 'David Copperfield', year: "1849"}
  end

  subject do
    ParsletExample.search("books", query)["hits"]["hits"]
  end

  context 'matches by title' do
    let(:query) do
      "title:Count"
    end

    it{ expect(subject.count).to eq 1 }
    it{ expect(subject.first).to include("_id" => "1") }
  end

  context 'filters by year' do
    let(:query) do
      "year:1849"
    end

    it{ expect(subject.count).to eq 1 }
    it{ expect(subject.first).to include("_id" => "2") }
  end

  context 'filters by year range "lte"' do
    let(:query) do
      "year:__1845"
    end

    it{ expect(subject.count).to eq 1 }
    it{ expect(subject.first).to include("_id" => "1") }
  end

  context 'filters by year range "gte"' do
    let(:query) do
      "year:1845__"
    end

    it{ expect(subject.count).to eq 1 }
    it{ expect(subject.first).to include("_id" => "2") }
  end

  context 'filters by year range "between"' do
    let(:query) do
      "year:1842__1845"
    end

    it{ expect(subject.count).to eq 1 }
    it{ expect(subject.first).to include("_id" => "1") }
  end

  context 'matches by title and filters by year range "between"' do
    let(:query) do
      "title:Count,,year:1842__1845"
    end

    it{ expect(subject.count).to eq 1 }
    it{ expect(subject.first).to include("_id" => "1") }
  end
end
