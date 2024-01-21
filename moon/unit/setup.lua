-----------------------------------------------------------------
-- Unit testing helpers.
-----------------------------------------------------------------
local M = {}

-----------------------------------------------------------------
-- Test setup.
-----------------------------------------------------------------
function M.new_pack()
  -- Disallow duplicate test names to catch mistakes.
  local store = {}
  return setmetatable( {}, {
    __index=function( _, k ) return store[k] end,
    __newindex=function( _, k, v )
      assert( not store[k], 'duplicate test name: ' .. k )
      store[k] = v
    end,
    ---@diagnostic disable-next-line: redundant-return-value
    __pairs=function() return pairs( store ) end,
  } )
end

-----------------------------------------------------------------
-- Finished.
-----------------------------------------------------------------
return M
