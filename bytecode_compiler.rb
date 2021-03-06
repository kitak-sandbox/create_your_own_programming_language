require File.expand_path("../bytecode", __FILE__)
require File.expand_path("../parser", __FILE__)

class BytecodeCompiler
    def initialize
        @parser = Parser.new
        @bytecode = []
    end

    def compile(code)
        @parser.parse(code).compile(self)
        emit RETURN
        @bytecode
    end

    def emit(opcode, *operands) # Usage: emit OPCODE, operand1, operand2, ...
        @bytecode << opcode
        @bytecode.concat operands
    end
end

class Nodes
    def compile(compiler)
        nodes.each do |node|
            node.compile(compiler)
        end
    end
end

class NumberNode
    def compile(compiler)
        compiler.emit PUSH_NUMBER, value
    end
end

class CallNode
    def compile(compiler)
        if receiver
            receiver.compile(compiler)
        else
            compiler.emit PUSH_SELF # Default to self if no receiver
        end

        arguments.each do |argument| # Compile the arguments
            argument.compile(compiler)
        end

        compiler.emit CALL, method, arguments.size
    end
end



