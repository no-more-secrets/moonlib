-----------------------------------------------------------------
-- GNU Plot generator.
-----------------------------------------------------------------
-- Generates runnable self-contained .gnuplot files.
-----------------------------------------------------------------
-- Imports.
-----------------------------------------------------------------
local logger = require( 'moon.logger' )

-----------------------------------------------------------------
-- Aliases.
-----------------------------------------------------------------
local format = string.format
local info = logger.info

-----------------------------------------------------------------
-- Implementation.
-----------------------------------------------------------------
local function line_graph( csv_data, opts )
  assert( opts.title )
  assert( opts.x_label )
  assert( opts.y_label )

  assert( csv_data.header )
  assert( csv_data.rows )

  local out = {}

  local function emit( what )
    table.insert( out, tostring( what ) )
  end

  local function emit_line( what )
    what = what or ''
    emit( what )
    emit( '\n' )
  end

  local function emit_row( row )
    local sep = ''
    for _, col in ipairs( row ) do
      emit( sep )
      sep = ','
      emit( '"' .. col .. '"' )
    end
    emit( '\n' )
  end

  emit_line( '#!/usr/bin/env -S gnuplot -p' )
  emit_line( 'set datafile separator comma' )
  emit_line()

  emit_line( '$CSVData << EOF' )
  emit_row( csv_data.header )
  for _, row in ipairs( csv_data.rows ) do emit_row( row ) end
  emit_line( 'EOF' )
  emit_line()

  emit_line( format( 'set title "%s"', opts.title ) )
  emit_line( 'set key outside right' )
  emit_line( 'set grid' )
  emit_line( format( 'set xlabel "%s"', opts.x_label ) )
  emit_line( format( 'set ylabel "%s"', opts.y_label ) )
  emit_line( 'set key autotitle columnhead' )
  if opts.x_range then
    emit_line( format( 'set xrange [%s]', opts.x_range ) )
  end
  if opts.y_range then
    emit_line( format( 'set yrange [%s]', opts.y_range ) )
  end
  emit_line(
      'plot for [col=2:*] $CSVData using 1:col with lines lw 2' )
  return table.concat( out )
end

local function line_graph_to_file( path, csv_data, opts )
  assert( path )
  info( 'writing gnuplot file %s...', path )
  local body = line_graph( csv_data, opts )
  local f<close> = assert( io.open( path, 'w' ), format(
                               'failed to open file %s',
                               tostring( path ) ) )
  f:write( body )
end

-----------------------------------------------------------------
-- Finished.
-----------------------------------------------------------------
return {
  line_graph=line_graph, --
  line_graph_to_file=line_graph_to_file, --
}