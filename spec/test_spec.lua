local test = require 'test'
local mach = require 'mach'

describe('test', function()
  it('should call the provided function', function()
    local f = mach.mock_function()

    f:should_be_called_with(3):when(function()
      test(f)
    end)
  end)
end)
