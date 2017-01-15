require File.expand_path("../bytecode", __FILE__) 
require File.expand_path("../runtime", __FILE__)

class VM
    def run(bytecode)
        stack = []
        ip = 0

        while true
            case bytecode[ip] # Inspect the current byte, this will be the opcode.
            when PUSH_NUMBER
                ip += 1 # Advance to next byte, the operand
                value = bytecode[ip] # Read the operand

                stack.push Constants["Number"].new_with_value(value)
            when PUSH_SELF
                stack.push RootContext.curent_self
            when CALL
                ip += 1 # Next byte contains the method name to call.
                method = bytecode[ip]

                ip += 1 # Next byte. the number of arguments on the stack.
                argc = bytecode[ip]

                args = []
                argc.times do
                    args << stack.pop
                end
                receiver = stack.pop

                stack.push receiver.call(method, args)
            when RETURN
                return stack.pop
            end

            ip += 1
        end
    end
end
