
require 'test/unit'
require File.expand_path('../../vm', __FILE__)

class VMTest < Test::Unit::TestCase
    def test_run
        bytecode = [
            PUSH_NUMBER, 1,
            PUSH_NUMBER, 2,
            CALL, "+", 1,
            RETURN
        ]
        result = VM.new.run(bytecode)

        assert_equal 3, result.ruby_value
    end
end