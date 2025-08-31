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
local ASSERT = assertion.ASSERT
local ASSERT_EQ = assertion.ASSERT_EQ

local count_keys = tbl.count_keys
local tables_equal = tbl.tables_equal

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

function Test.tables_equal()
  local l = {}
  local r = {}

  ASSERT( tables_equal( l, r ) )

  l = { a=1 }
  r = { a=1 }
  ASSERT( tables_equal( l, r ) )

  l = { a=1, b=2 }
  r = { a=1, b=2 }
  ASSERT( tables_equal( l, r ) )

  l = { a=1, b=2, c=3 }
  r = { a=1, b=2, c=3 }
  ASSERT( tables_equal( l, r ) )

  do
    l = { a=1, b=2, c=3 }
    r = { a=1, b=3, c=3 }
    local ok, k, l_v, r_v = tables_equal( l, r )
    ASSERT( not ok )
    ASSERT_EQ( k, 'b' )
    ASSERT_EQ( l_v, 2 )
    ASSERT_EQ( r_v, 3 )
  end

  do
    l = { a=1, b=2, c=3 }
    r = { b=2, c=3 }
    local ok, k, l_v, r_v = tables_equal( l, r )
    ASSERT( not ok )
    ASSERT_EQ( k, 'a' )
    ASSERT_EQ( l_v, 1 )
    ASSERT_EQ( r_v, nil )
  end

  l = { a=1, b=2, c={} }
  r = { a=1, b=2, c={} }
  ASSERT( tables_equal( l, r ) )

  l = { a=1, b=2, c={ d=5, e=8 } }
  r = { a=1, b=2, c={ d=5, e=8 } }
  ASSERT( tables_equal( l, r ) )

  local ok, k, l_v, r_v

  l = { a=1, b=2, c={ d=5, e=8, f=0 } }
  r = { a=1, b=2, c={ d=5, e=8 } }
  ok, k, l_v, r_v = tables_equal( l, r )
  ASSERT( not ok )
  ASSERT_EQ( k, 'f' )
  ASSERT_EQ( l_v, 0 )
  ASSERT_EQ( r_v, nil )

  l = { a=1, b=2, c={ d=5, e=8 } }
  r = { a=1, b=2, c={ d=5, e=8, f=0 } }
  ok, k, l_v, r_v = tables_equal( l, r )
  ASSERT( not ok )
  ASSERT_EQ( k, 'f' )
  ASSERT_EQ( l_v, 0 )
  ASSERT_EQ( r_v, nil )
end
