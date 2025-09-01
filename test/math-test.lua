-----------------------------------------------------------------
-- Tests for the math module.
-----------------------------------------------------------------
local Test = ...

-----------------------------------------------------------------
-- Imports.
-----------------------------------------------------------------
local assertion = require'moon.unit.assertion'
local mmath = require'moon.math'

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

local clamp = mmath.clamp

-----------------------------------------------------------------
-- Test cases.
-----------------------------------------------------------------
function Test.clamp()
  ASSERT_EQ( clamp( 0, 0, 0 ), 0 )

  ASSERT_EQ( clamp( 0, 2, 5 ), 2 )
  ASSERT_EQ( clamp( 1, 2, 5 ), 2 )
  ASSERT_EQ( clamp( 2, 2, 5 ), 2 )
  ASSERT_EQ( clamp( 3, 2, 5 ), 3 )
  ASSERT_EQ( clamp( 4, 2, 5 ), 4 )
  ASSERT_EQ( clamp( 5, 2, 5 ), 5 )
  ASSERT_EQ( clamp( 6, 2, 5 ), 5 )
  ASSERT_EQ( clamp( 7, 2, 5 ), 5 )

  ASSERT_EQ( clamp( -5, -2, 5 ), -2 )
  ASSERT_EQ( clamp( -4, -2, 5 ), -2 )
  ASSERT_EQ( clamp( -3, -2, 5 ), -2 )
  ASSERT_EQ( clamp( -2, -2, 5 ), -2 )
  ASSERT_EQ( clamp( -1, -2, 5 ), -1 )
  ASSERT_EQ( clamp( 0, -2, 5 ), 0 )
  ASSERT_EQ( clamp( 1, -2, 5 ), 1 )
  ASSERT_EQ( clamp( 2, -2, 5 ), 2 )
  ASSERT_EQ( clamp( 3, -2, 5 ), 3 )
  ASSERT_EQ( clamp( 4, -2, 5 ), 4 )
  ASSERT_EQ( clamp( 5, -2, 5 ), 5 )
  ASSERT_EQ( clamp( 6, -2, 5 ), 5 )
  ASSERT_EQ( clamp( 7, -2, 5 ), 5 )
end
