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
local ASSERT_TABLE_EQ = assertion.ASSERT_TABLE_EQ

local join = list.join
local split = list.split
local tsplit = list.tsplit
local tsplit_trim = list.tsplit_trim
local split_trim = list.split_trim

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

function Test.split()
  local input, sep, expected

  input = ''
  sep = ','
  expected = { '' }
  ASSERT_TABLE_EQ( split( input, sep ), expected )

  input = ''
  sep = ','
  expected = { '' }
  ASSERT_TABLE_EQ( split_trim( input, sep ), expected )

  input = ''
  sep = ','
  expected = {}
  ASSERT_TABLE_EQ(
      split_trim( input, sep, { remove_empty=true } ), expected )

  input = 'a'
  sep = '|'
  expected = { 'a' }
  ASSERT_TABLE_EQ( split( input, sep ), expected )

  input = 'abc|'
  sep = '|'
  expected = { 'abc', '' }
  ASSERT_TABLE_EQ( split( input, sep ), expected )

  input = '|abc|'
  sep = '|'
  expected = { '', 'abc', '' }
  ASSERT_TABLE_EQ( split( input, sep ), expected )

  input = 'aaa-bbb-ccc'
  sep = '-'
  expected = { 'aaa', 'bbb', 'ccc' }
  ASSERT_TABLE_EQ( split( input, sep ), expected )

  input = 'aaa,  bbb, ccc '
  sep = ','
  expected = { 'aaa', '  bbb', ' ccc ' }
  ASSERT_TABLE_EQ( split( input, sep ), expected )

  input = 'aaa,  bbb, ccc '
  sep = ','
  expected = { 'aaa', 'bbb', 'ccc' }
  ASSERT_TABLE_EQ( split_trim( input, sep ), expected )

  input = 'aaa--bbb-ccc'
  sep = '-'
  expected = { 'aaa', '', 'bbb', 'ccc' }
  ASSERT_TABLE_EQ( split( input, sep ), expected )

  do
    input = 'xxx=yyy|aaa=bbb|ccc=ddd\thello=2/1/0'
    local part1, part2 = tsplit( input, '\t' )
    local xxx_yyy, aaa_bbb, ccc_ddd = tsplit( part1, '|' )
    local hello, nums = tsplit( part2, '=' )
    local xxx, yyy = tsplit( xxx_yyy, '=' )
    local aaa, bbb = tsplit( aaa_bbb, '=' )
    local ccc, ddd = tsplit( ccc_ddd, '=' )
    ASSERT_EQ( hello, 'hello' )
    ASSERT_EQ( nums, '2/1/0' )
    ASSERT_EQ( xxx, 'xxx' )
    ASSERT_EQ( yyy, 'yyy' )
    ASSERT_EQ( aaa, 'aaa' )
    ASSERT_EQ( bbb, 'bbb' )
    ASSERT_EQ( ccc, 'ccc' )
    ASSERT_EQ( ddd, 'ddd' )
  end

  do
    input = 'aaa, bbb, ccc   ; comment'
    local config = split_trim( input, ';' )[1]
    local aaa, bbb, ccc = tsplit_trim( config, ',' )
    ASSERT_EQ( aaa, 'aaa' )
    ASSERT_EQ( bbb, 'bbb' )
    ASSERT_EQ( ccc, 'ccc' )
  end

  do
    input = 'aaa, bbb, ccc'
    local config = split_trim( input, ';' )[1]
    local aaa, bbb, ccc = tsplit_trim( config, ',' )
    ASSERT_EQ( aaa, 'aaa' )
    ASSERT_EQ( bbb, 'bbb' )
    ASSERT_EQ( ccc, 'ccc' )
  end

  do
    input = 'aaa, bbb, ccc'
    local config = split_trim( input, ';' )[1]
    local aaa, bbb, ccc = tsplit_trim( config, ',',
                                       { remove_empty=true } )
    ASSERT_EQ( aaa, 'aaa' )
    ASSERT_EQ( bbb, 'bbb' )
    ASSERT_EQ( ccc, 'ccc' )
  end

  do
    input = ' ; aaa, bbb, ccc'
    local config = split_trim( input, ';' )[1]
    local items =
        split_trim( config, ',', { remove_empty=true } )
    ASSERT_EQ( #items, 0 )
  end

  do
    input = ' xxx ; aaa, bbb, ccc'
    local config = split_trim( input, ';' )[1]
    local items =
        split_trim( config, ',', { remove_empty=true } )
    ASSERT_EQ( #items, 1 )
    ASSERT_EQ( items[1], 'xxx' )
  end
end

-----------------------------------------------------------------
-- Finished.
-----------------------------------------------------------------
return Test
