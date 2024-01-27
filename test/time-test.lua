-----------------------------------------------------------------
-- Tests for the printer module.
-----------------------------------------------------------------
local Test = ...

-----------------------------------------------------------------
-- Imports.
-----------------------------------------------------------------
local assertion = require'moon.unit.assertion'
local time = require'moon.time'

-----------------------------------------------------------------
-- Freeze global access.
-----------------------------------------------------------------
-- Declare all globals used.
-- None.

-- No reading or writing of globals from here on.
local _ENV = nil

-----------------------------------------------------------------
-- Aliases.
-----------------------------------------------------------------
local ASSERT_GE = assertion.ASSERT_GE
local ASSERT_EQ = assertion.ASSERT_EQ

local now_micros = time.now_micros
local sleep = time.sleep
local timeit_micros = time.timeit_micros

-----------------------------------------------------------------
-- Test cases.
-----------------------------------------------------------------
function Test.now_micros()
  local now = now_micros()
  ASSERT_GE( now, 1706387206188896 )
end

-- This also tests sleep.
function Test.timeit_micros()
  local runtime, x, y, z = timeit_micros( function()
    sleep( .001 )
    return 3, 2, 1
  end )
  ASSERT_GE( runtime, 900 )
  ASSERT_EQ( x, 3 )
  ASSERT_EQ( y, 2 )
  ASSERT_EQ( z, 1 )
end

-----------------------------------------------------------------
-- Finished.
-----------------------------------------------------------------
return Test
