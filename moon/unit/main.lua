-----------------------------------------------------------------
-- Runs a group of unit test files.
-----------------------------------------------------------------
-----------------------------------------------------------------
-- Imports.
-----------------------------------------------------------------
local colors = require'moon.colors'
local err = require'moon.err'
local printer = require'moon.printer'
local setup = require'moon.unit.setup'

-----------------------------------------------------------------
-- Aliases.
-----------------------------------------------------------------
local format = string.format
local rep = string.rep
local sort = table.sort
local insert = table.insert
local pcall = err.pcall_traceback
local printfln = printer.printfln

-----------------------------------------------------------------
-- Constants.
-----------------------------------------------------------------
local GREEN = colors.ANSI_GREEN
local BLUE = colors.ANSI_BLUE
local NORMAL = colors.ANSI_NORMAL
local RED = colors.ANSI_RED
local YELLOW = colors.ANSI_YELLOW
local MAGENTA = colors.ANSI_MAGENTA

-----------------------------------------------------------------
-- Methods.
-----------------------------------------------------------------
local function run_test_cases( module_name, pack )
  local sorted_names = {}
  local longest_length = 0
  for name in pairs( pack ) do
    if #name > longest_length then longest_length = #name end
    insert( sorted_names, name )
  end
  sort( sorted_names )
  for _, name in ipairs( sorted_names ) do
    io.write( format( 'running test case %s%s%s.%s%s%s%s',
                      MAGENTA, module_name, NORMAL, BLUE, name,
                      NORMAL, rep( '.', longest_length-#name+3 ) ) )
    io.flush()
    local ok, res = pcall( pack[name] )
    if ok then
      io.write( GREEN .. ' passed' .. NORMAL .. '.\n' )
    else
      io.write( RED .. ' failed' .. NORMAL .. '.\n' )
      printfln( '%s%s%s', YELLOW, res, NORMAL )
      return false
    end
  end
  return true
end

-----------------------------------------------------------------
-- Main.
-----------------------------------------------------------------
local function main( files )
  for _, file in ipairs( files ) do
    local f = assert( loadfile( file ) )
    local test_pack = assert( setup.new_pack() )
    assert( type( test_pack ) == 'table' )
    assert( f( test_pack ) )
    local module_name = assert( file:match( '(.*)%.lua' ) )
    local ok = run_test_cases( module_name, test_pack )
    if not ok then break end
  end
end

main{ ... }
