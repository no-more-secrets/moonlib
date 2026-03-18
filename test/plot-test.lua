-----------------------------------------------------------------
-- Tests for the plot module.
-----------------------------------------------------------------
local Test = ...

-----------------------------------------------------------------
-- Imports.
-----------------------------------------------------------------
local assertion = require'moon.unit.assertion'
local plot = require'moon.plot'

-----------------------------------------------------------------
-- Freeze global access.
-----------------------------------------------------------------
-- Declare all globals used.
local table = table

-- No reading or writing of globals from here on.
local _ENV = nil

-----------------------------------------------------------------
-- Aliases.
-----------------------------------------------------------------
local ASSERT_EQ = assertion.ASSERT_EQ

-----------------------------------------------------------------
-- Test cases.
-----------------------------------------------------------------
function Test.line_graph()
  local opts = {
    title='Some Title',
    x_label='Some X Label',
    y_label='Some Y Label',
    x_range='0:100',
    y_range='0:6',
  }
  local csv_data = { header={ 'x', 'line1', 'line2' }, rows={} }
  for i = 1, 10 do
    local row = {}
    table.insert( row, i * i )
    table.insert( row, i / 2 )
    table.insert( row, i / 3 )
    table.insert( csv_data.rows, row )
  end
  local body = plot.line_graph( csv_data, opts )
  -- plot.line_graph_to_file( '/tmp/moon.test.gnuplot', csv_data,
  --                          opts )
  local expected_body = [[
#!/usr/bin/env -S gnuplot -p
set datafile separator comma

$CSVData << EOF
"x","line1","line2"
"1","0.5","0.33333333333333"
"4","1.0","0.66666666666667"
"9","1.5","1.0"
"16","2.0","1.3333333333333"
"25","2.5","1.6666666666667"
"36","3.0","2.0"
"49","3.5","2.3333333333333"
"64","4.0","2.6666666666667"
"81","4.5","3.0"
"100","5.0","3.3333333333333"
EOF

set title "Some Title"
set key outside right
set grid
set xlabel "Some X Label"
set ylabel "Some Y Label"
set key autotitle columnhead
set xrange [0:100]
set yrange [0:6]
plot for [col=2:*] $CSVData using 1:col with lines lw 2
]]

  ASSERT_EQ( body, expected_body )
end
