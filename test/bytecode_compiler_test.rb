
require 'test/unit'
require File.expand_path('../../bytecode_compiler', __FILE__)

class BytecodeCompilerTest < Test::Unit::TestCase
    def test_compile
        bytecode = BytecodeCompiler.new.compile("print(1+2)")
        expected_bytecode = [
            PUSH_SELF,
            PUSH_NUMBER, 1,
            PUSH_NUMBER, 2,
            CALL, "+", 1,
            CALL, "print", 1,
            RETURN
        ]
        assert_equal expected_bytecode, bytecode
        assert_output("3\n") { VM.new.run(bytecode) }
    end
end