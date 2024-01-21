-----------------------------------------------------------------
-- Functional programming stuff.
-----------------------------------------------------------------
local M = {}

-----------------------------------------------------------------
-- Aliases.
-----------------------------------------------------------------
local insert = table.insert

-----------------------------------------------------------------
-- Methods.
-----------------------------------------------------------------
function M.map( f, lst )
  assert( type( lst ) == 'table' )
  local res = {}
  for _, e in ipairs( lst ) do insert( res, f( e ) ) end
  return res
end

function M.for_each( lst, f )
  assert( type( lst ) == 'table' )
  for _, e in ipairs( lst ) do f( e ) end
end

-----------------------------------------------------------------
-- Finished.
-----------------------------------------------------------------
return M
