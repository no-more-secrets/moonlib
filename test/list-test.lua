-----------------------------------------------------------------
-- Tests for the printer module.
-----------------------------------------------------------------
local Test = ...

-----------------------------------------------------------------
-- Imports.
-----------------------------------------------------------------
local assertion = require'moon.unit.assertion'
local list = require'moon.list'

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

local join = list.join

-----------------------------------------------------------------
-- Test cases.
-----------------------------------------------------------------
function Test.list_join()
  local input, sep, expected

  input = {}
  sep = ''
  expected = ''
  ASSERT_EQ( join( input, sep ), expected )

  input = { '' }
  sep = ''
  expected = ''
  ASSERT_EQ( join( input, sep ), expected )

  input = { '' }
  sep = '|'
  expected = ''
  ASSERT_EQ( join( input, sep ), expected )

  input = { 'a' }
  sep = '|'
  expected = 'a'
  ASSERT_EQ( join( input, sep ), expected )

  input = { 'a', 'b' }
  sep = '|'
  expected = 'a|b'
  ASSERT_EQ( join( input, sep ), expected )

  input = { 'aaa', 'bcd', 'ccc' }
  sep = ','
  expected = 'aaa,bcd,ccc'
  ASSERT_EQ( join( input, sep ), expected )

  input = { 'hello', 'world', 'hello', 'world', 'world' }
  sep = '-'
  expected = 'hello-world-hello-world-world'
  ASSERT_EQ( join( input, sep ), expected )
end

-----------------------------------------------------------------
-- Finished.
-----------------------------------------------------------------
return Test
