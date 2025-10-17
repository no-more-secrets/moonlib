-----------------------------------------------------------------
-- File methods.
-----------------------------------------------------------------
local M = {}

-----------------------------------------------------------------
-- Imports.
-----------------------------------------------------------------
local cmd = require'moon.cmd'
local str = require'moon.str'

-----------------------------------------------------------------
-- Aliases.
-----------------------------------------------------------------
local insert = table.insert
local format = string.format
local command = cmd.command
local trim = str.trim

-----------------------------------------------------------------
-- Implementation.
-----------------------------------------------------------------
function M.exists( name )
  -- TODO: use <close> here.
  local f = io.open( name, 'r' )
  return f ~= nil and f:close()
end

-- The lines do NOT contain newlines at the end.
function M.read_file_lines( name )
  local f<close> = assert( io.open( name, 'r' ) )
  local res = {}
  for line in f:lines() do insert( res, line ) end
  return res
end

function M.append_string_to_file( filename, what )
  -- TODO: use <close> here.
  local f = assert( io.open( filename, 'a+' ) )
  f:write( what )
  f:close()
end

function M.copy_file( src, dst, options )
  options = options or {}
  options.force = options.force or false
  if not options.force and M.exists( dst ) then
    error( format( 'cannot overwrite file %s', dst ) )
  end
  do
    local infile<close> = assert( io.open( src, 'rb' ) )
    local outfile<close> = assert( io.open( dst, 'wb' ) )
    outfile:write( infile:read( '*a' ) )
  end
end

function M.realpath( p ) return trim( command( 'realpath', p ) ) end

-----------------------------------------------------------------
-- Finished.
-----------------------------------------------------------------
return M
