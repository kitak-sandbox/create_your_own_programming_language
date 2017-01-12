class Context
    attr_reader :locals, :current_self, :current_class

    def inialize(current_self, current_class=current_self.runtime_class)
        @locals = {}
        @current_self = current_self
        @current_class = current_class
    end
end