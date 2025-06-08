-----------------------------------------------------------------
-- List methods.
-----------------------------------------------------------------
local M = {}

-----------------------------------------------------------------
-- Imports.
-----------------------------------------------------------------
local mtbl = require'moon.tbl'

-----------------------------------------------------------------
-- Aliases.
-----------------------------------------------------------------
local count_keys = mtbl.count_keys

-----------------------------------------------------------------
-- Implementation.
-----------------------------------------------------------------
function M.set( list )
  local set = {}
  for _, e in ipairs( list ) do set[e] = true end
  return set
end

function M.set_size( set ) return count_keys( set ) end

-----------------------------------------------------------------
-- Finished.
-----------------------------------------------------------------
-- This allows using `set` as both the module name and as a set
-- constructor, which is desirable syntactically.
return setmetatable( {}, {
  __index=M,
  __call=function( _, ... ) return M.set( ... ) end,
} )
