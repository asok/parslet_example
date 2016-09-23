require "parslet_example/version"
require "parslet_example/parser"
require "parslet_example/transform"

module ParsletExample
  def search(index, input)
    q = Transform.new.apply(Parser.new.parse(input))
    client = Elasticsearch::Client.new

    client.search(index: index, body: {query: q})
  end

  extend self
end
