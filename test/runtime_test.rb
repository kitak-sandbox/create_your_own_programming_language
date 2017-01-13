
require 'test/unit'
require File.expand_path('../../runtime', __FILE__)

class RuntimeTest < Test::Unit::TestCase
    def test_runtime
        object = Constants["Object"].call("new")

        assert_equal Constants["Object"], object.runtime_class
    end
end