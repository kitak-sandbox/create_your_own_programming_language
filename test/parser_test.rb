require 'test/unit'
require File.expand_path('../../parser.rb', __FILE__)

class ParserTest < Test::Unit::TestCase
    def test_parsing
        code = <<-CODE
def method(a, b):
  true
CODE

        nodes = Nodes.new([
            DefNode.new("method", ["a", "b"],
                Nodes.new([TrueNode.new])
            )
        ])
        assert_equal nodes, Parser.new.parse(code)
    end
end