class Lexer
    KEYWORDS = ["def", "class", "if", "true", "false", "nil", "while"]

    def tokenize(code)
        code.chomp! # Remove extra line breaks
        tokens = [] # This will hold the generated tokens

        current_indent = 0 # number of spaces in the last indent
        indent_stacks = []

        i = 0 # Current character position
        while i < code.size
            chunk = code[i..-1]

            if identifier = chunk[/\A([a-z]\w*)/, 1]
                if KEYWORDS.include?(identifier) # keywords will generate [:IF, "if"]
                    tokens << [identifier.upcase.to_sym, identifier]
                else
                    tokens << [:IDENTIFIER, identifier]
                end
                i += identifier.size
            elsif constant = chunk[/\A([A-Z]\w*)/, 1]
                tokens << [:CONSTANT, constant]
                i += constant.size
            elsif number = chunk[/\A([0-9]+)/, 1]
                tokens << [:NUMBER, number.to_i]
                i += number.size
            elsif string = chunk[/\A"([^"]*)"/, 1]
                tokens << [:STRING, string]
                i += string.size + 2 # skip two more to exclude the `"`.
            elsif indent = chunk[/\A\:\n( +)/m, 1] # Matches ":<newline><spaces>"
                if indent.size < current_indent # indent should go up when creating a block
                    raise "Bad indent lavel, got #{indent.size} indents, " +
                            "expected > #{current_indent}"
                end
                current_indent = indent.size
                indent_stacks.push(current_indent)
                tokens << [:INDENT, indent.size]
                i += indent.size + 2
            elsif indent = chunk[/\A\n( *)/m, 1]
                if indent.size == current_indent
                    tokens << [:NEWLINE, "\n"] # Nothing to do, we are still 
                elsif indent.size < current_indent
                    while indent.size < current_indent
                        indent_stacks.pop
                        current_indent = indent_stacks.last || 0
                        tokens << [:DEDENT, indent.size]
                    end
                    tokens << [:NEWLINE, "\n"]
                else # indent.size > current_indent, error! 
                    require 'pp'
                    pp tokens
                    raise "Missing ':'" # Cannot increate indent level without using ":"
                end
                i += indent.size + 1
            elsif operator = chunk[/\A(\|\||&&|==|!=|<=|>=)/, 1]
                tokens << [operator, operator]
                i += operator.size
            elsif chunk.match(/\A /)
                i += 1
            else
                value = chunk[0, 1]
                tokens << [value, value]
                i += 1
            end
        end

        while indent = indent_stacks.pop
            tokens << [:DEDENT, indent_stacks.last || 0]
        end

        tokens
    end
end
