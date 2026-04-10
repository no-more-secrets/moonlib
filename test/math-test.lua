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
local table = table
local assert = assert

-- No reading or writing of globals from here on.
local _ENV = nil

-----------------------------------------------------------------
-- Aliases.
-----------------------------------------------------------------
local sort = assert( table.sort )

local ASSERT_EQ = assertion.ASSERT_EQ
local ASSERT = assertion.ASSERT

local clamp = mmath.clamp
local shuffle = mmath.shuffle

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

function Test.shuffle()
  local lst = { 'd', 'b', 'f', 'a', 'e', 'c', 'g' }
  local sorted = { 'a', 'b', 'c', 'd', 'e', 'f', 'g' }

  local function equal()
    ASSERT_EQ( #lst, 7 )
    ASSERT_EQ( #sorted, 7 )
    for i = 1, 7 do
      if lst[i] ~= sorted[i] then return false end
    end
    return true
  end

  repeat ASSERT_EQ( shuffle( lst ), nil ) until not equal()
  ASSERT( not equal() )

  sort( lst )

  ASSERT_EQ( #lst, 7 )
  ASSERT_EQ( lst[1], 'a' )
  ASSERT_EQ( lst[2], 'b' )
  ASSERT_EQ( lst[3], 'c' )
  ASSERT_EQ( lst[4], 'd' )
  ASSERT_EQ( lst[5], 'e' )
  ASSERT_EQ( lst[6], 'f' )
  ASSERT_EQ( lst[7], 'g' )
end
