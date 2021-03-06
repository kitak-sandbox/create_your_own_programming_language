require File.expand_path("../parser", __FILE__)
require File.expand_path("../runtime", __FILE__)

class Interpreter
    def initialize
        @parser = Parser.new
    end

    def eval(code)
        @parser.parse(code).eval(RootContext)
    end
end

class Nodes
    def eval(context)
        return_value = nil
        nodes.each do |node|
            return_value = node.eval(context)
        end
        return_value || Constants["nil"] # Last result is return value (or nil if none)
    end
end

class NumberNode
    def eval(context)
        Constants["Number"].new_with_value(value)
    end
end

class StringNode
    def eval(context)
        Constants["String"].new_with_value(value)
    end
end

class TrueNode
    def eval(context)
        Constants["true"]
    end
end

class FalseNode
    def eval(context)
        Constants["false"]
    end
end

class NilNode
    def eval(context)
        Constants["nil"]
    end
end

class GetConstantNode
    def eval(context)
        Constants[name]
    end
end

class GetLocalNode
    def eval(context)
        context.locals[name]
    end
end

class SetConstantNode
    def eval(context)
        Constants[name] = value.eval(context)
    end
end

class SetLocalNode
    def eval(context)
        context.locals[name] = value.eval(context)
    end
end

class CallNode
    def eval(context)
        if receiver
            value = receiver.eval(context)
        else
            value = context.current_self # default to `self` if no receiver.
        end

        evaluated_arguments = arguments.map { |arg| arg.eval(context) }
        value.call(method, evaluated_arguments)
    end
end

class DefNode
    def eval(context)
        method = AwesomeMethod.new(params, body)
        context.current_class.runtime_methods[name] = method
    end
end

class ClassNode
    def eval(context)
        awesome_class = Constants[name] # Check if class is already defined

        unless awesome_class # Class does not exist yet
            awesome_class = AwesomeClass.new
            Constants[name] = awesome_class # Define the class in the runtime
        end

        class_context = Context.new(awesome_class, awesome_class)
        body.eval(class_context)

        awesome_class
    end
end

class IfNode
    def eval(context)
        if condition.eval(context).ruby_value
            body.eval(context)
        else # If no body is evaluated, we return nil
            Constants["nil"]
        end
    end
end


