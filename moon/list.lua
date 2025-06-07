-----------------------------------------------------------------
-- List methods.
-----------------------------------------------------------------
local M = {}

-----------------------------------------------------------------
-- Imports.
-----------------------------------------------------------------
local mstr = require'moon.str'

-----------------------------------------------------------------
-- Aliases.
-----------------------------------------------------------------
local insert = table.insert
local unpack = table.unpack
local concat = table.concat
local format = string.format
local trim = mstr.trim

-----------------------------------------------------------------
-- Implementation.
-----------------------------------------------------------------
function M.join( lst, sep ) return concat( lst, sep ) end

function M.listify( iter )
  local res = {}
  for e in iter do insert( res, e ) end
  return res
end

-- sep can be muliple chars including pattern matchers.
function M.split( str, sep )
  assert( type( str ) == 'string' )
  sep = sep or '%s'
  local anti_sep = format( '[^%s]*', sep )
  return M.listify( str:gmatch( anti_sep ) )
end

-- Split but return the results as a tuple:
--   E.g. local k, v = tsplit( 'hello=world', '=' )
function M.tsplit( str, sep )
  return unpack( M.split( str, sep ) ) --
end

function M.tsplit_trim( str, sep, opts )
  return unpack( M.split_trim( str, sep, opts ) ) --
end

function M.split_trim( str, sep, opts )
  opts = opts or {}
  opts.remove_empty = opts.remove_empty or false
  local untrimmed = M.split( str, sep )
  local trimmed = {}
  for _, e in ipairs( untrimmed ) do
    local s = trim( e )
    if #s == 0 and opts.remove_empty then goto continue end
    insert( trimmed, trim( e ) )
    ::continue::
  end
  return trimmed
end

-----------------------------------------------------------------
-- Finished.
-----------------------------------------------------------------
return M
