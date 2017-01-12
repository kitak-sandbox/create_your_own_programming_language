
require 'test/unit'
require File.expand_path('../../runtime/object', __FILE__)
require File.expand_path('../../runtime/class', __FILE__)
require File.expand_path('../../runtime/context', __FILE__)
require File.expand_path('../../runtime/method', __FILE__)
require File.expand_path('../../runtime/bootstrap', __FILE__)

class RuntimeTest < Test::Unit::TestCase
    def test_runtime
        object = Constants["Object"].call("new")

        assert_equal Constants["Object"], object.runtime_class
    end
end