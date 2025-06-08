-----------------------------------------------------------------
-- Tests for the printer module.
-----------------------------------------------------------------
local Test = ...

-----------------------------------------------------------------
-- Imports.
-----------------------------------------------------------------
local assertion = require'moon.unit.assertion'
local set = require'moon.set'

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
local ASSERT_TABLE_EQ = assertion.ASSERT_TABLE_EQ

local set_size = set.set_size

-----------------------------------------------------------------
-- Test cases.
-----------------------------------------------------------------
function Test.set_and_size()
  local input, expected

  input = {}
  expected = {}
  ASSERT_TABLE_EQ( set( input ), expected )
  ASSERT_EQ( set_size( set( input ) ), 0 )

  input = { 0 }
  expected = { [0]=true }
  ASSERT_TABLE_EQ( set( input ), expected )
  ASSERT_EQ( set_size( set( input ) ), 1 )

  input = { 9, 6, 4, 5, 3, 6, 4, 5, 6 }
  expected = { [9]=true, [6]=true, [4]=true, [5]=true, [3]=true }
  ASSERT_TABLE_EQ( set( input ), expected )
  ASSERT_EQ( set_size( set( input ) ), 5 )

  input = { 'hello', 'hello', 'world' }
  expected = { hello=true, world=true }
  ASSERT_TABLE_EQ( set( input ), expected )
  ASSERT_EQ( set_size( set( input ) ), 2 )
end

-----------------------------------------------------------------
-- Finished.
-----------------------------------------------------------------
return Test
