-----------------------------------------------------------------
-- Table methods.
-----------------------------------------------------------------
local M = {}

-----------------------------------------------------------------
-- Aliases.
-----------------------------------------------------------------
local insert = table.insert
local sort = table.sort

-----------------------------------------------------------------
-- Implementation.
-----------------------------------------------------------------
function M.on_ordered_kv( tbl, op )
  local keys = {}
  for k, _ in pairs( tbl ) do insert( keys, k ) end
  sort( keys )
  for _, k in ipairs( keys ) do
    local v = tbl[k]
    assert( v ~= nil ) -- v could be `false`.
    op( k, v )
  end
end

-- Actually supports any type; if it is not a table it will just
-- get returned since only tables are mutable.
function M.deep_copy( thing )
  if type( thing ) ~= 'table' then return thing end
  local res = {}
  for k, v in pairs( thing ) do
    res[M.deep_copy( k )] = M.deep_copy( v )
  end
  return res
end

-----------------------------------------------------------------
-- Finished.
-----------------------------------------------------------------
return M
