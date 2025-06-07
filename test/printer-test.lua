-----------------------------------------------------------------
-- Tests for the printer module.
-----------------------------------------------------------------
local Test = ...

-----------------------------------------------------------------
-- Imports.
-----------------------------------------------------------------
local assertion = require'moon.unit.assertion'
local printer = require'moon.printer'

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

local to_json_oneline = printer.to_json_oneline

-----------------------------------------------------------------
-- Test cases.
-----------------------------------------------------------------
function Test.format_data_table__empty_table()
  local input = { column_names={}, row_names={}, data={} }
  local expected = ''
  local tbl = printer.format_data_table( input )
  ASSERT_EQ( '\n' .. tbl, '\n' .. expected )
end

function Test.format_data_table__one_by_one()
  local input = {
    column_names={ 'col1' },
    row_names={ 'row1' },
    data={ { 'value' } },
  }
  local expected = [[
         col1
row1    value]]
  local tbl = printer.format_data_table( input )
  ASSERT_EQ( '\n' .. tbl, '\n' .. expected )
end

function Test.format_data_table__four_by_three()
  local input = {
    column_names={ 'col1', 'col2', 'col3', 'col4' },
    row_names={ 'row1', 'row2', 'row3' },
    data={
      { '11', '12', '13', '14' },
      { '21', '22', '23_long', '24' },
      { '31', '32', '33', '34' },
    },
  }
  local expected = [[
        col1  col2     col3  col4
row1      11    12       13    14
row2      21    22  23_long    24
row3      31    32       33    34]]
  local tbl = printer.format_data_table( input )
  ASSERT_EQ( '\n' .. tbl, '\n' .. expected )
end

function Test.format_data_table__one_by_three()
  local input = {
    column_names={ 'col1' },
    row_names={ 'row1', 'row2_long', 'row3' },
    data={ { '11' }, { '21' }, { '31' } },
  }
  local expected = [[
             col1
row1           11
row2_long      21
row3           31]]
  local tbl = printer.format_data_table( input )
  ASSERT_EQ( '\n' .. tbl, '\n' .. expected )
end

function Test.format_kv_table()
  local input = { hello=1, world='foo' }
  local expected = '[hello=1|world=foo]'
  local res = printer.format_kv_table( input, {
    start='[',
    ending=']',
    kv_sep='=',
    pair_sep='|',
  } )
  ASSERT_EQ( res, expected )
end

function Test.to_json_oneline()
  local tbl, expected

  local function f() return to_json_oneline( tbl ) end

  tbl = nil
  expected = 'null'
  ASSERT_EQ( f(), expected )

  tbl = {}
  expected = '{}'
  ASSERT_EQ( f(), expected )

  tbl = 5
  expected = '5'
  ASSERT_EQ( f(), expected )

  tbl = 5.6
  expected = '5.6'
  ASSERT_EQ( f(), expected )

  tbl = 'hello'
  expected = '"hello"'
  ASSERT_EQ( f(), expected )

  tbl = { 'hello', 'world' }
  expected = '["hello","world"]'
  ASSERT_EQ( f(), expected )

  tbl = { hello='world', aaa='bbb' }
  expected = '{"aaa":"bbb","hello":"world"}'
  ASSERT_EQ( f(), expected )

  tbl = {
    hello='world',
    nested={
      'elem1', 5, 7, { ccc='ddd', ddd={ hhh={ 'a', 3, 2 } } },
      'nine',
    },
    aaa='bbb',
  }
  expected =
      '{"aaa":"bbb","hello":"world","nested":["elem1",5,7,{"ccc":"ddd","ddd":{"hhh":["a",3,2]}},"nine"]}'
  ASSERT_EQ( f(), expected )
end

-----------------------------------------------------------------
-- Finished.
-----------------------------------------------------------------
return Test
