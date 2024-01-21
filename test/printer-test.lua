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

-----------------------------------------------------------------
-- Test cases.
-----------------------------------------------------------------
function Test.empty_table()
  local input = { column_names={}, row_names={}, data={} }
  local expected = ''
  local tbl = printer.format_data_table( input )
  ASSERT_EQ( '\n' .. tbl, '\n' .. expected )
end

function Test.one_by_one()
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

function Test.four_by_three()
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

function Test.one_by_three()
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

-----------------------------------------------------------------
-- Finished.
-----------------------------------------------------------------
return Test
