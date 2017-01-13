
require 'test/unit'
require File.expand_path('../../interpreter', __FILE__)

class InterpreterTest < Test::Unit::TestCase
    def test_eval
        code = <<-CODE
class Awesome:
  def does_it_work:
    "yeah!"

awesome_object = Awesome.new
if awesome_object:
  print(awesome_object.does_it_work)
CODE
        assert_output("yeah!\n") { Interpreter.new.eval(code) }
    end
end