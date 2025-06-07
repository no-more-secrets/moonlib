-----------------------------------------------------------------
-- Tests for the printer module.
-----------------------------------------------------------------
local Test = ...

-----------------------------------------------------------------
-- Imports.
-----------------------------------------------------------------
local assertion = require'moon.unit.assertion'
local tbl = require'moon.tbl'

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
local ASSERT_EQ = assertion.ASSERT_EQ

local count_keys = tbl.count_keys

-----------------------------------------------------------------
-- Test cases.
-----------------------------------------------------------------
function Test.count_keys()
  local input

  local f = count_keys

  input = {}
  ASSERT_EQ( f( input ), 0 )

  input = { a=1 }
  ASSERT_EQ( f( input ), 1 )

  input = { a=1, b=2 }
  ASSERT_EQ( f( input ), 2 )

  input = { 4, 5, 6, a=1, b=2 }
  ASSERT_EQ( f( input ), 5 )

  input = { 4, 5, 6, a=1, b=2 }
  input[2] = 9
  ASSERT_EQ( f( input ), 5 )
end

-----------------------------------------------------------------
-- Finished.
-----------------------------------------------------------------
return Test
